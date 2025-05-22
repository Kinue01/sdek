use std::time::Duration;

use axum::http::Method;
use axum::routing::{get, post};
use axum::Router;
use dotenvy::dotenv;
use tower::ServiceBuilder;
use tower_http::cors::{Any, CorsLayer};
use tower_http::trace;
use tower_http::trace::TraceLayer;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use handlers::*;

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
            "/transportservice/api/type",
            post(add_transport_type)
                .patch(update_transport_type)
                .delete(delete_transport_type),
        )
        .route(
            "/transportservice/api/transport",
            post(add_transport)
                .patch(update_transport)
                .delete(delete_transport),
        )
        .route("/transportservice/api/track_transport", get(ws_transport_update))
        .merge(SwaggerUi::new("/transportservice/swagger").url("/transportservice/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(event_client)
        .layer(ServiceBuilder::new().layer(tracing).layer(cors));

    let listener = tokio::net::TcpListener::bind("transportservice:8005")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    axum::serve(listener, app).await.unwrap();
}
