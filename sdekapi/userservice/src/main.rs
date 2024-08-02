use std::time::Duration;

use axum::{http::Method, Router, routing::get};
use dotenvy::dotenv;
use redis::aio::MultiplexedConnection;
use sqlx::PgPool;
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
    paths(
        handlers::get_users,
        handlers::get_roles,
        handlers::get_user_by_id,
        handlers::get_clients,
        handlers::get_client_by_id,
        handlers::add_client,
        handlers::update_client,
        handlers::delete_client,
        handlers::get_positions,
        handlers::add_position,
        handlers::update_position,
        handlers::delete_position,
        handlers::get_employees,
        handlers::get_employee_by_id,
        handlers::add_employee,
        handlers::update_employee,
        handlers::delete_employee
    ),
    components(schemas(
        User,
        RoleResponse,
        Client,
        Employee,
        PositionResponse,
        UserResponse,
        ClientResponse,
        EmployeeResponse
    ))
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

    let db_url = std::env::var("DATABASE_URL").unwrap();

    let pool = PgPoolOptions::new()
        .max_connections(1000000)
        .acquire_timeout(Duration::from_secs(10))
        .connect(&db_url)
        .await
        .unwrap();

    let redis = redis::Client::open("redis://127.0.0.1/?protocol=resp3")
        .unwrap()
        .get_multiplexed_async_connection()
        .await
        .unwrap();

    let state = AppState {
        postgres: pool,
        redis,
    };

    let app = Router::new()
        .route("/api/roles", get(get_roles))
        .route("/api/users", get(get_users))
        .route("/api/user", get(get_user_by_id))
        .route("/api/clients", get(get_clients))
        .route(
            "/api/client",
            get(get_client_by_id)
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
        .route("/api/employees", get(get_employees))
        .route(
            "/api/employee",
            get(get_employee_by_id)
                .post(add_employee)
                .patch(update_employee)
                .delete(delete_employee),
        )
        .merge(SwaggerUi::new("/swagger").url("/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(state)
        .layer(tracing)
        .layer(cors);

    let listener = tokio::net::TcpListener::bind("localhost:8000")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    axum::serve(listener, app).await.unwrap();
}
