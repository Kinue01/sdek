use std::time::Duration;

use axum::extract::State;
use axum::http::Method;
use axum::Router;
use axum::routing::get;
use dotenvy::dotenv;
use mongodb::Client;
use redis::aio::MultiplexedConnection;
use sqlx::{Pool, Postgres};
use sqlx::postgres::PgPoolOptions;
use tower::ServiceBuilder;
use tower_http::cors::{Any, CorsLayer};
use tower_http::trace;
use tower_http::trace::TraceLayer;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use crate::handlers::{
    get_transport, get_transport_by_driver_id, get_transport_by_id, get_transport_type_by_id,
    get_transport_types, update_db_main, update_db_types, update_mongo,
};

mod error;
mod handlers;
mod model;

#[derive(OpenApi)]
#[openapi(paths(), components(schemas()))]
struct ApiDoc;

#[derive(Clone)]
struct AppState {
    postgres: Pool<Postgres>,
    redis: MultiplexedConnection,
    mongo: Client,
    event_client: eventstore::Client,
    http_client: reqwest::Client,
}

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt()
        .with_target(false)
        .compact()
        .init();

    let cors = CorsLayer::new()
        .allow_methods([Method::GET, Method::POST, Method::PATCH, Method::DELETE])
        .allow_origin(Any)
        .allow_headers(Any);

    let tracing = TraceLayer::new_for_http()
        .make_span_with(trace::DefaultMakeSpan::new().level(tracing::Level::INFO))
        .on_response(trace::DefaultOnResponse::new().level(tracing::Level::INFO));

    dotenv().ok();

    let pg_url = std::env::var("DATABASE_URL").unwrap_or_default();
    let redis_url = std::env::var("REDIS_URL").unwrap_or_default();
    let mongo_url = std::env::var("MONGO_URL").unwrap_or_default();
    let es_url = std::env::var("EVENTSTORE_URL").unwrap_or_default();

    let postgres = PgPoolOptions::new()
        .max_connections(1000000)
        .acquire_timeout(Duration::from_secs(10))
        .connect(&pg_url)
        .await
        .unwrap();

    let redis = redis::Client::open(redis_url)
        .unwrap()
        .get_multiplexed_async_connection()
        .await
        .unwrap();

    let mongo = Client::with_uri_str(mongo_url).await.unwrap();

    let event_client = eventstore::Client::new(es_url.parse().unwrap_or_default()).unwrap();

    let http_client = reqwest::ClientBuilder::new().build().unwrap();

    let state = AppState {
        postgres,
        redis,
        mongo,
        event_client,
        http_client,
    };

    let app = Router::new()
        .route("/api/transport", get(get_transport_by_id))
        .route("/api/transports", get(get_transport))
        .route("/api/transport_types", get(get_transport_types))
        .route("/api/transport_type", get(get_transport_type_by_id))
        .route("/api/transport_driver", get(get_transport_by_driver_id))
        .merge(SwaggerUi::new("/swagger").url("/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(state.clone())
        .layer(ServiceBuilder::new().layer(tracing).layer(cors));

    let listener = tokio::net::TcpListener::bind("localhost:8015")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    tokio::spawn(update_db_types(State(state.clone())))
        .await
        .unwrap();
    tokio::spawn(update_db_main(State(state.clone())))
        .await
        .unwrap();
    tokio::spawn(update_mongo(State(state))).await.unwrap();

    axum::serve(listener, app).await.unwrap();
}
