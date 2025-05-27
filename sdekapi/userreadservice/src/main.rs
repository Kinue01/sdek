use std::thread;
use std::time::Duration;

use crate::error::*;
use crate::handlers::{get_role_by_id, get_roles, get_user_by_id, get_users, update_db};
use crate::model::*;
use axum::extract::State;
use axum::http::Method;
use axum::routing::get;
use axum::{middleware, Router};
use dotenvy::dotenv;
use futures::TryFutureExt;
use redis::aio::MultiplexedConnection;
use sqlx::postgres::PgPoolOptions;
use sqlx::PgPool;
use tower::ServiceBuilder;
use tower_http::cors::{Any, CorsLayer};
use tower_http::trace;
use tower_http::trace::TraceLayer;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;
use uuid::Variant::Future;

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
    let es_url = std::env::var("EVENTSTORE_URL").unwrap_or_default();

    let pool = PgPoolOptions::new()
        .max_connections(5)
        .min_connections(1)
        .acquire_timeout(Duration::from_secs(120))
        .idle_timeout(Duration::from_secs(10))
        .connect_lazy(pg_url.as_str())
        .map_err(MyError::DBError)
        .unwrap();

    let event_client = eventstore::Client::new(es_url.parse().unwrap()).unwrap();

    let state = AppState {
        postgres: pool,
        event_client,
    };

    let app = Router::new()
        .route("/userreadservice/api/roles", get(get_roles))
        .route("/userreadservice/api/role", get(get_role_by_id))
        .route("/userreadservice/api/users", get(get_users))
        .route("/userreadservice/api/user", get(get_user_by_id))
        .merge(SwaggerUi::new("/userreadservice/swagger").url("/userreadservice/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(state.clone())
        .layer(ServiceBuilder::new().layer(tracing).layer(cors));

    let listener = tokio::net::TcpListener::bind("userreadservice:8010")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    let st = state.clone();
    tokio::spawn(async move {
        update_db(State(st)).await
    });

    axum::serve(listener, app).await.unwrap();
}
