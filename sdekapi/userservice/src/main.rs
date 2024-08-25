use axum::{http::Method, Router, routing::get};
use axum::routing::post;
use axum_session::{SessionConfig, SessionLayer, SessionNullPool, SessionStore};
use dotenvy::dotenv;
use oauth2::{AuthUrl, ClientId, ClientSecret, RedirectUrl, StandardRevocableToken, TokenUrl};
use oauth2::basic::{
    BasicClient, BasicErrorResponse, BasicRevocationErrorResponse, BasicTokenIntrospectionResponse,
    BasicTokenResponse, BasicTokenType,
};
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
    components(schemas(User, RoleResponse, Message, CodeResponse))
)]
struct ApiDoc;

#[derive(Clone)]
struct AppState {
    oauth_client: oauth2::Client<
        BasicErrorResponse,
        BasicTokenResponse,
        BasicTokenType,
        BasicTokenIntrospectionResponse,
        StandardRevocableToken,
        BasicRevocationErrorResponse,
    >,
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

    let google_client_id = ClientId::new(
        std::env::var("GOOGLE_CLIENT_ID")
            .expect("Missing the GOOGLE_CLIENT_ID environment variable."),
    );
    let google_client_secret = ClientSecret::new(
        std::env::var("GOOGLE_CLIENT_SECRET")
            .expect("Missing the GOOGLE_CLIENT_SECRET environment variable."),
    );
    let auth_url = AuthUrl::new(std::env::var("GOOGLE_AUTH_URI").unwrap())
        .expect("Invalid authorization endpoint URL");
    let token_url = TokenUrl::new(std::env::var("GOOGLE_TOKEN_URI").unwrap())
        .expect("Invalid token endpoint URL");

    let oauth_client = BasicClient::new(
        google_client_id,
        Some(google_client_secret),
        auth_url,
        Some(token_url),
    )
    .set_redirect_uri(
        RedirectUrl::new("http://localhost:8080".to_string()).expect("Invalid redirect URL"),
    );

    let event_client = eventstore::Client::new(es_url.parse().unwrap()).unwrap();

    let state = AppState {
        oauth_client,
        event_client,
    };

    let conf = SessionConfig::default().with_table_name("auth_table");
    let store = SessionStore::<SessionNullPool>::new(None, conf)
        .await
        .unwrap();

    let app = Router::new()
        .route(
            "/api/user",
            post(add_user).patch(update_user).delete(delete_user),
        )
        .route("/api/msg", post(send_msg_kafka))
        .route("/api/google_get_url", get(google_oauth2_req))
        .route("/api/google_get_token", post(google_oauth2_token))
        .route("/api/google_revoke_token", post(revoke_google_token))
        .merge(SwaggerUi::new("/swagger").url("/api-doc/openapi.json", ApiDoc::openapi()))
        .with_state(state)
        .layer(
            ServiceBuilder::new()
                .layer(tracing)
                .layer(cors)
                .layer(SessionLayer::new(store)),
        );

    let listener = tokio::net::TcpListener::bind("localhost:8000")
        .await
        .unwrap();
    tracing::info!("listening on {}", listener.local_addr().unwrap());

    axum::serve(listener, app).await.unwrap();
}
