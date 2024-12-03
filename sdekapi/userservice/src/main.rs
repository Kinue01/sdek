use axum::{http::Method, Router, routing::get};
use axum::routing::post;
use dotenvy::dotenv;
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
    paths(handlers::send_msg_kafka),
    components(schemas(User, RoleResponse, Message))
)]
struct ApiDoc;

#[derive(Clone)]
struct AppState {
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

    let es_url = std::env::var("EVENTSTORE_URL").unwrap();
    let event_client = eventstore::Client::new(es_url.parse().unwrap()).unwrap();

    let state = AppState {
        event_client,
    };

    let app = Router::new()
        .route(
            "/userservice/api/user",
            post(add_user).patch(update_user).delete(delete_user),
        )
        .route("/userservice/api/msg", post(send_msg_kafka))
        .merge(SwaggerUi::new("/userservice/swagger").url("/userservice/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(state)
        .layer(
            ServiceBuilder::new()
                .layer(tracing)
                .layer(cors)
        );

    let listener = tokio::net::TcpListener::bind("userservice:8000")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    axum::serve(listener, app).await.unwrap();
}
