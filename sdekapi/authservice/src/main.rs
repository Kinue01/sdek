use axum::routing::post;
use axum::{http::Method, Router};
use axum_session::{SessionConfig, SessionLayer, SessionNullPool, SessionStore};
use dotenvy::dotenv;
use redis::aio::MultiplexedConnection;
use sqlx::postgres::PgPoolOptions;
use sqlx::PgPool;
use std::time::Duration;
use tower::ServiceBuilder;
use tower_http::{
    cors::{Any, CorsLayer},
    trace::{self, TraceLayer},
};
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use crate::{handlers::*, model::*};

mod error;
mod handlers;
mod model;

#[derive(OpenApi)]
#[openapi(
    components(schemas(User, RoleResponse, CodeResponse))
)]
struct ApiDoc;

#[derive(Clone)]
struct AppState {
    postgres: PgPool,
    redis: MultiplexedConnection,
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
    let redis_url = std::env::var("REDIS_URL").unwrap_or_default();

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

    let state = AppState {
        postgres: pool,
        redis
    };

    let conf = SessionConfig::default().with_table_name("auth_table");
    let store = SessionStore::<SessionNullPool>::new(None, conf)
        .await
        .unwrap();

    let app = Router::new()
        .route("/authservice/api/user", post(get_user_by_login_pass))
        .merge(SwaggerUi::new("/authservice/swagger").url("/authservice/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(state)
        .layer(
            ServiceBuilder::new()
                .layer(tracing)
                .layer(cors)
                .layer(SessionLayer::new(store)),
        );

    let listener = tokio::net::TcpListener::bind("authservice:8020")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    axum::serve(listener, app).await.unwrap();
}
