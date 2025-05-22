use std::time::Duration;

use axum::extract::State;
use axum::http::Method;
use axum::routing::get;
use axum::Router;
use dotenvy::dotenv;
use redis::aio::MultiplexedConnection;
use sqlx::postgres::PgPoolOptions;
use sqlx::PgPool;
use tower::ServiceBuilder;
use tower_http::cors::{Any, CorsLayer};
use tower_http::trace;
use tower_http::trace::TraceLayer;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use crate::handlers::{get_employee_by_id, get_employee_by_user_id, get_employees, get_position_by_id, get_positions, update_db_main, update_db_poses};

mod error;
mod handlers;
mod model;

#[derive(OpenApi)]
#[openapi(paths(), components(schemas()))]
struct ApiDoc;

#[derive(Clone)]
struct AppState {
    postgres: PgPool,
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
    let es_url = std::env::var("EVENTSTORE_URL").unwrap_or_default();

    let pool = PgPoolOptions::new()
        .max_connections(5)
        .acquire_timeout(Duration::from_secs(120))
        .connect(&pg_url)
        .await
        .unwrap();

    let redis = redis::Client::open(redis_url)
        .unwrap()
        .get_multiplexed_async_connection()
        .await
        .unwrap();

    let event_client = eventstore::Client::new(es_url.parse().unwrap()).unwrap();

    let state = AppState {
        postgres: pool,
        redis,
        event_client,
    };

    let app = Router::new()
        .route("/employeereadservice/api/position", get(get_position_by_id))
        .route("/employeereadservice/api/employee", get(get_employee_by_id))
        .route("/employeereadservice/api/employees", get(get_employees))
        .route("/employeereadservice/api/positions", get(get_positions))
        .route("/employeereadservice/api/employee_user", get(get_employee_by_user_id))
        .merge(SwaggerUi::new("/employeereadservice/swagger").url("/employeereadservice/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(state.clone())
        .layer(ServiceBuilder::new().layer(tracing).layer(cors));

    let listener = tokio::net::TcpListener::bind("employereadeservice:8012")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    let st2 = state.clone();
    tokio::spawn(async move {
        update_db_poses(State(st2)).await
    });

    let st = state.clone();
    tokio::spawn(async move {
        update_db_main(State(st)).await
    });

    axum::serve(listener, app).await.unwrap();
}
