use std::time::Duration;

use axum::extract::State;
use axum::http::Method;
use axum::Router;
use axum::routing::get;
use dotenvy::dotenv;
use redis::aio::MultiplexedConnection;
use sqlx::{Pool, Postgres};
use sqlx::postgres::PgPoolOptions;
use tower::ServiceBuilder;
use tower_http::cors::{Any, CorsLayer};
use tower_http::trace;
use tower_http::trace::TraceLayer;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use crate::handlers::{get_client_packages_by_id, get_package_by_id, get_package_status_by_id, get_package_statuses, get_package_type_by_id, get_package_types, get_packages, get_packages_paytypes, update_db_main, update_db_statuses, update_db_types};

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
        .make_span_with(trace::DefaultMakeSpan::new().level(tracing::Level::INFO))
        .on_response(trace::DefaultOnResponse::new().level(tracing::Level::INFO));

    dotenv().ok();

    let pg_url = std::env::var("DATABASE_URL").unwrap_or_default();
    let redis_url = std::env::var("REDIS_URL").unwrap_or_default();
    let mongo_url = std::env::var("MONGO_URL").unwrap_or_default();
    let es_url = std::env::var("EVENTSTORE_URL").unwrap_or_default();

    let postgres = PgPoolOptions::new()
        .max_connections(1000000)
        .acquire_timeout(Duration::from_secs(60))
        .connect(&pg_url)
        .await
        .unwrap();

    let redis = redis::Client::open(redis_url)
        .unwrap()
        .get_multiplexed_async_connection()
        .await
        .unwrap();

    let event_client = eventstore::Client::new(es_url.parse().unwrap_or_default()).unwrap();

    let state = AppState {
        postgres,
        redis,
        event_client,
    };

    let app = Router::new()
        .route("/packagereadservice/api/packages", get(get_packages))
        .route("/packagereadservice/api/package", get(get_package_by_id))
        .route("/packagereadservice/api/package_types", get(get_package_types))
        .route("/packagereadservice/api/package_type", get(get_package_type_by_id))
        .route("/packagereadservice/api/package_statuses", get(get_package_statuses))
        .route("/packagereadservice/api/package_status", get(get_package_status_by_id))
        .route("/packagereadservice/api/client_packages", get(get_client_packages_by_id))
        .route("/packagereadservice/api/package_paytypes", get(get_packages_paytypes))
        .merge(SwaggerUi::new("/packagereadservice/swagger").url("/packagereadservice/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(state.clone())
        .layer(ServiceBuilder::new().layer(tracing).layer(cors));

    let listener = tokio::net::TcpListener::bind("packagereadservice:8013")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    let st = state.clone();
    tokio::spawn(async move {
        update_db_types(State(st)).await
    });
    
    let st2 = state.clone();
    tokio::spawn(async move {
        update_db_statuses(State(st2)).await
    });
    
    let st3 = state.clone();
    tokio::spawn(async move {
        update_db_main(State(st3)).await
    });

    axum::serve(listener, app).await.unwrap();
}
