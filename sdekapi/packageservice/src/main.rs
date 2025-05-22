use axum::http::Method;
use axum::routing::post;
use axum::Router;
use dotenvy::dotenv;
use tower::ServiceBuilder;
use tower_http::cors::{Any, CorsLayer};
use tower_http::trace;
use tower_http::trace::TraceLayer;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use crate::handlers::{
    add_package, add_package_status, add_package_type, delete_package, delete_package_status,
    delete_package_type, update_package, update_package_status, update_package_type,
};

mod error;
mod handlers;
mod model;

#[derive(OpenApi)]
#[openapi(paths(), components(schemas()))]
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

    let es_url = std::env::var("EVENTSTORE_URL").unwrap_or_default();

    let event_client = eventstore::Client::new(es_url.parse().unwrap_or_default()).unwrap();

    let app = Router::new()
        .route(
            "/packageservice/api/type",
            post(add_package_type)
                .patch(update_package_type)
                .delete(delete_package_type),
        )
        .route(
            "/packageservice/api/status",
            post(add_package_status)
                .patch(update_package_status)
                .delete(delete_package_status),
        )
        .route(
            "/packageservice/api/package",
            post(add_package)
                .patch(update_package)
                .delete(delete_package),
        )
        .merge(SwaggerUi::new("/packageservice/swagger").url("/packageservice/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(event_client)
        .layer(ServiceBuilder::new().layer(tracing).layer(cors));

    let listener = tokio::net::TcpListener::bind("packageservice:8003")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    axum::serve(listener, app).await.unwrap();
}
