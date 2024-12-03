use axum::http::Method;
use axum::Router;
use axum::routing::{get, post};
use dotenvy::dotenv;
use tower::ServiceBuilder;
use tower_http::cors::{Any, CorsLayer};
use tower_http::trace;
use tower_http::trace::TraceLayer;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use crate::handlers::{add_client, delete_client, update_client};

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
        .make_span_with(trace::DefaultMakeSpan::new().level(tracing::Level::INFO))
        .on_response(trace::DefaultOnResponse::new().level(tracing::Level::INFO));

    dotenv().ok();

    let es_url = std::env::var("EVENTSTORE_URL").unwrap_or_default();

    let event_client = eventstore::Client::new(es_url.parse().unwrap_or_default()).unwrap();

    let app = Router::new()
        .route(
            "/customerservice/api/client",
            post(add_client).patch(update_client).delete(delete_client),
        )
        .merge(SwaggerUi::new("/customerservice/swagger").url("/customerservice/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(event_client)
        .layer(ServiceBuilder::new().layer(tracing).layer(cors));

    let listener = tokio::net::TcpListener::bind("consumerservice:8001")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    axum::serve(listener, app).await.unwrap();
}
