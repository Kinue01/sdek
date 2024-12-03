use axum::http::Method;
use axum::Router;
use axum::routing::{get, post};
use dotenvy::dotenv;
use eventstore::Client;
use tower::ServiceBuilder;
use tower_http::cors::{Any, CorsLayer};
use tower_http::trace;
use tower_http::trace::TraceLayer;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use crate::handlers::{
    add_employee, add_position, delete_employee, delete_position, update_employee, update_position,
};

mod error;
mod handlers;
mod model;

#[derive(OpenApi)]
#[openapi(paths(), components(schemas()))]
struct ApiDoc;

#[derive(Clone)]
struct AppState {
    event_client: Client,
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

    let event_client =
        Client::new("esdb://admin:@eventstore:2113".parse().unwrap_or_default()).unwrap();

    let state = AppState { event_client };

    let app = Router::new()
        .route(
            "/employeeservice/api/position",
            post(add_position)
                .patch(update_position)
                .delete(delete_position),
        )
        .route(
            "/employeeservice/api/employee",
            post(add_employee)
                .patch(update_employee)
                .delete(delete_employee),
        )
        .merge(SwaggerUi::new("/employeeservice/swagger").url("/employeeservice/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(state)
        .layer(ServiceBuilder::new().layer(tracing).layer(cors));

    let listener = tokio::net::TcpListener::bind("employeeservice:8002")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    axum::serve(listener, app).await.unwrap();
}
