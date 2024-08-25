use axum::extract::{Json, State};
use axum::http::StatusCode;
use axum_session::{Session, SessionNullPool};
use eventstore::EventData;
use oauth2::{
    AccessToken, AuthorizationCode, CsrfToken, EmptyExtraTokenFields, PkceCodeChallenge,
    PkceCodeVerifier, Scope, StandardRevocableToken, TokenResponse,
};
use oauth2::basic::{BasicTokenResponse, BasicTokenType};
use oauth2::reqwest::async_http_client;
use serde::Deserialize;
use utoipa::IntoParams;
use uuid::Uuid;

use crate::{AppState, model::*};
use crate::error::MyError;

pub async fn add_user(
    State(state): State<AppState>,
    Json(user): Json<User>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("user_add", user).unwrap();
    let _ = state
        .event_client
        .append_to_stream("user", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::CREATED)
}

pub async fn update_user(
    State(state): State<AppState>,
    Json(user): Json<User>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("user_update", user).unwrap();
    let _ = state
        .event_client
        .append_to_stream("user", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

pub async fn delete_user(
    State(state): State<AppState>,
    Json(user): Json<User>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("user_delete", user).unwrap();
    let _ = state
        .event_client
        .append_to_stream("user", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

#[utoipa::path(
    get,
    path = "/api/google_get_url",
    responses(
        (status = 200, description = "Token requested", body = String),
        (status = 500, description = "Failed request token")
    )
)]
pub async fn google_oauth2_req(
    State(state): State<AppState>,
    session: Session<SessionNullPool>,
) -> Result<String, MyError> {
    let (pkce_challenge, pkce_verifier) = PkceCodeChallenge::new_random_sha256();

    let (auth_url, csrf_token) = state
        .oauth_client
        .authorize_url(CsrfToken::new_random)
        .add_scope(Scope::new(
            "https://www.googleapis.com/auth/contacts.readonly".to_string(),
        ))
        .set_pkce_challenge(pkce_challenge)
        .url();

    session.set("csrf_token", csrf_token);
    session.set("pkce_verifier", pkce_verifier);

    Ok(auth_url.to_string())
}

#[utoipa::path(
    post,
    path = "/api/google_get_token",
    request_body(content = Json<CodeResponse>, description = "Code"),
    responses(
        (status = 200, description = "Token requested", body = Json<BasicTokenResponse>),
        (status = 500, description = "Failed request token")
    )
)]
pub async fn google_oauth2_token(
    State(state): State<AppState>,
    session: Session<SessionNullPool>,
    Json(resp): Json<CodeResponse>,
) -> Result<Json<BasicTokenResponse>, MyError> {
    let ver: PkceCodeVerifier = session.get("pkce_verifier").unwrap();
    let c_state: CsrfToken = session.get("csrf_token").unwrap();

    match resp.state == c_state.secret().as_str() {
        true => {
            let token = state
                .oauth_client
                .exchange_code(AuthorizationCode::new(resp.code))
                .set_pkce_verifier(ver)
                .request_async(async_http_client)
                .await
                .unwrap();

            session.set(token.access_token().secret(), token.extra_fields());

            Ok(Json(token))
        }
        false => Ok(Json(BasicTokenResponse::new(
            AccessToken::new("".to_string()),
            BasicTokenType::Bearer,
            EmptyExtraTokenFields {},
        ))),
    }
}

#[derive(Deserialize, IntoParams)]
struct TokenQuery {
    uuid: Uuid,
}

#[utoipa::path(
    post,
    path = "/api/google_revoke_token",
    request_body(content = Json<String>, description = "Secret"),
    responses(
        (status = 200, description = "Token revoked"),
        (status = 500, description = "Failed revoke token")
    )
)]
pub async fn revoke_google_token(
    State(state): State<AppState>,
    session: Session<SessionNullPool>,
    Json(secret): Json<String>,
) -> Result<StatusCode, MyError> {
    let token_resp: BasicTokenResponse = BasicTokenResponse::new(
        AccessToken::new(secret.clone()),
        BasicTokenType::Bearer,
        session.get(secret.as_str()).unwrap(),
    );

    let revoke: StandardRevocableToken = match token_resp.refresh_token() {
        Some(token) => token.into(),
        None => token_resp.access_token().into(),
    };

    state
        .oauth_client
        .revoke_token(revoke)
        .unwrap()
        .request_async(async_http_client)
        .await
        .unwrap_or_default();

    Ok(StatusCode::OK)
}

#[utoipa::path(
    post,
    path = "/api/msg",
    request_body(content = Json<Message>, description = "Message"),
    responses(
        (status = 201, description = "Message sent"),
        (status = 500, description = "Can`t send message")
    )
)]
pub async fn send_msg_kafka(
    State(state): State<AppState>,
    Json(msg): Json<Message>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("notification_send", msg).unwrap();
    let _ = state
        .event_client
        .append_to_stream("notification", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}
