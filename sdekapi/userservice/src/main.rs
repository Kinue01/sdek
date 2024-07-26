use std::time::Duration;

use axum::{
    http::Method,
    Router,
    routing::{delete, get, post, put},
};
use dotenvy::dotenv;
use sqlx::postgres::PgPoolOptions;
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
    paths(handlers::get_users, handlers::get_roles),
    components(schemas(User, RoleResponse, Client, Employee, PositionResponse))
)]
struct ApiDoc;

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

    let db_url = std::env::var("DATABASE_URL").unwrap();

    let pool = PgPoolOptions::new()
        .max_connections(1000000)
        .acquire_timeout(Duration::from_secs(10))
        .connect(&db_url)
        .await
        .unwrap();

    let app = Router::new()
        .route("/api/roles", get(get_roles))
        .route("/api/users", get(get_users).get(get_user_by_id))
        .route(
            "/api/clients",
            get(get_clients)
                .get(get_client_by_id)
                .post(add_client)
                .patch(update_client)
                .delete(delete_client),
        )
        .route(
            "/api/positions",
            get(get_positions)
                .post(add_position)
                .patch(update_position)
                .delete(delete_position),
        )
        .route(
            "/api/employees",
            get(get_employees)
                .get(get_employee_by_id)
                .post(add_employee)
                .patch(update_employee)
                .delete(delete_employee),
        )
        .merge(SwaggerUi::new("/swagger-ui").url("/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(pool)
        .layer(tracing)
        .layer(cors);

    let listener = tokio::net::TcpListener::bind("localhost:8000")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    axum::serve(listener, app).await.unwrap();
}
