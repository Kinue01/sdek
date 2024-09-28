use std::time::Duration;

use axum::extract::State;
use axum::http::Method;
use axum::Router;
use axum::routing::get;
use dotenvy::dotenv;
use redis::aio::MultiplexedConnection;
use sqlx::PgPool;
use sqlx::postgres::PgPoolOptions;
use tower::ServiceBuilder;
use tower_http::cors::{Any, CorsLayer};
use tower_http::trace;
use tower_http::trace::TraceLayer;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use crate::handlers::{get_role_by_id, get_roles, get_user_by_id, get_users, update_db};
use crate::model::*;

mod error;
mod handlers;
mod model;

#[derive(OpenApi)]
#[openapi(
    paths(
        handlers::get_users,
        handlers::get_roles,
        handlers::get_user_by_id,
        handlers::get_role_by_id
    ),
    components(schemas(User, RoleResponse, UserResponse))
)]
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

    let event_client = eventstore::Client::new(es_url.parse().unwrap()).unwrap();

    let state = AppState {
        postgres: pool,
        redis,
        event_client,
    };

    let app = Router::new()
        .route("/api/roles", get(get_roles))
        .route("/api/role", get(get_role_by_id))
        .route("/api/users", get(get_users))
        .route("/api/user", get(get_user_by_id))
        .merge(SwaggerUi::new("/swagger").url("/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(state.clone())
        .layer(ServiceBuilder::new().layer(tracing).layer(cors));

    let listener = tokio::net::TcpListener::bind("localhost:8010")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    tokio::spawn(update_db(State(state))).await.unwrap();

    axum::serve(listener, app).await.unwrap();
}