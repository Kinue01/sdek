use std::time::Duration;

use axum::extract::State;
use axum::http::Method;
use axum::routing::get;
use axum::Router;
use dotenvy::dotenv;
use handlers::get_trans_pos;
use mongodb::Client;
use redis::aio::MultiplexedConnection;
use sqlx::postgres::PgPoolOptions;
use sqlx::{Pool, Postgres};
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
    mongo: Client,
    event_client: eventstore::Client,
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
        .make_span_with(trace::DefaultMakeSpan::new().level(tracing::Level::DEBUG))
        .on_response(trace::DefaultOnResponse::new().level(tracing::Level::DEBUG));

    dotenv().ok();

    let pg_url = std::env::var("DATABASE_URL").unwrap_or_default();
    let mongo_url = std::env::var("MONGO_URL").unwrap_or_default();
    let es_url = std::env::var("EVENTSTORE_URL").unwrap_or_default();

    let postgres = PgPoolOptions::new()
        .max_connections(5)
        .min_connections(1)
        .acquire_timeout(Duration::from_secs(120))
        .idle_timeout(Duration::from_secs(10))
        .connect_lazy(&pg_url)
        .unwrap();
    let mongo = Client::with_uri_str(mongo_url).await.unwrap();
    let event_client = eventstore::Client::new(es_url.parse().unwrap_or_default()).unwrap();

    let state = AppState {
        postgres,
        mongo,
        event_client,
    };

    let app = Router::new()
        .route("/transportreadservice/api/transport", get(get_transport_by_id))
        .route("/transportreadservice/api/transports", get(get_transport))
        .route("/transportreadservice/api/transport_types", get(get_transport_types))
        .route("/transportreadservice/api/transport_type", get(get_transport_type_by_id))
        .route("/transportreadservice/api/transport_driver", get(get_transport_by_driver_id))
        .route("/transportreadservice/api/transport_pos", get(get_trans_pos))
        .merge(SwaggerUi::new("/transportreadservice/swagger").url("/transportreadservice/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(state.clone())
        .layer(ServiceBuilder::new().layer(tracing).layer(cors));

    let listener = tokio::net::TcpListener::bind("transportreadservice:8015")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    let st = state.clone();
    tokio::spawn(async move {
        update_db_types(State(st)).await
    });
    
    let st2 = state.clone();
    tokio::spawn(async move {
        update_db_main(State(st2)).await
    });
    
    let st3 = state.clone();
    tokio::spawn(async move {
        update_mongo(State(st3)).await
    });

    axum::serve(listener, app).await.unwrap();
}
