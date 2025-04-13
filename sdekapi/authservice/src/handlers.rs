use axum::extract::{Json, State};
use axum::http::StatusCode;
use axum_session::{Session, SessionNullPool};
use oauth2::{
    AccessToken, AuthorizationCode, CsrfToken, EmptyExtraTokenFields, PkceCodeChallenge,
    PkceCodeVerifier, Scope, StandardRevocableToken, TokenResponse,
};
use oauth2::basic::{BasicTokenResponse, BasicTokenType};
use oauth2::reqwest;
use redis::{AsyncCommands, JsonAsyncCommands};
use serde::Deserialize;
use utoipa::IntoParams;
use uuid::Uuid;

use crate::{AppState, model::*};
use crate::error::MyError;

// #[utoipa::path(
//     get,
//     path = "/api/google_get_url",
//     responses(
//         (status = 200, description = "Token requested", body = String),
//         (status = 500, description = "Failed request token")
//     )
// )]
// pub async fn google_oauth2_req(
//     State(state): State<AppState>,
//     session: Session<SessionNullPool>,
// ) -> Result<String, MyError> {
//     let (pkce_challenge, pkce_verifier) = PkceCodeChallenge::new_random_sha256();
// 
//     let (auth_url, csrf_token) = state
//         .oauth_client
//         .authorize_url(CsrfToken::new_random)
//         .add_scope(Scope::new(
//             "https://www.googleapis.com/auth/contacts.readonly".to_string(),
//         ))
//         .set_pkce_challenge(pkce_challenge)
//         .url();
// 
//     session.set("csrf_token", csrf_token);
//     session.set("pkce_verifier", pkce_verifier);
// 
//     Ok(auth_url.to_string())
// }
// 
// #[utoipa::path(
//     post,
//     path = "/api/google_get_token",
//     request_body(content = CodeResponse, description = "Code"),
//     responses(
//         (status = 200, description = "Token requested", body = String),
//         (status = 500, description = "Failed request token")
//     )
// )]
// pub async fn google_oauth2_token(
//     State(state): State<AppState>,
//     session: Session<SessionNullPool>,
//     Json(resp): Json<CodeResponse>,
// ) -> Result<Json<BasicTokenResponse>, MyError> {
//     let ver: PkceCodeVerifier = session.get("pkce_verifier").unwrap();
//     let c_state: CsrfToken = session.get("csrf_token").unwrap();
// 
//     match resp.state == c_state.secret().as_str() {
//         true => {
//             let token = state
//                 .oauth_client
//                 .exchange_code(AuthorizationCode::new(resp.code))
//                 .set_pkce_verifier(ver)
//                 .request_async(async_http_client)
//                 .await
//                 .unwrap();
// 
//             session.set(token.access_token().secret(), token.extra_fields());
// 
//             Ok(Json(token))
//         }
//         false => Ok(Json(BasicTokenResponse::new(
//             AccessToken::new("".to_string()),
//             BasicTokenType::Bearer,
//             EmptyExtraTokenFields {},
//         ))),
//     }
// }
// 
// #[derive(Deserialize, IntoParams)]
// struct TokenQuery {
//     uuid: Uuid,
// }
// 
// #[utoipa::path(
//     post,
//     path = "/api/google_revoke_token",
//     request_body(content = String, description = "Secret"),
//     responses(
//         (status = 200, description = "Token revoked"),
//         (status = 500, description = "Failed revoke token")
//     )
// )]
// pub async fn revoke_google_token(
//     State(state): State<AppState>,
//     session: Session<SessionNullPool>,
//     Json(secret): Json<String>,
// ) -> Result<StatusCode, MyError> {
//     let token_resp: BasicTokenResponse = BasicTokenResponse::new(
//         AccessToken::new(secret.clone()),
//         BasicTokenType::Bearer,
//         session.get(secret.as_str()).unwrap(),
//     );
// 
//     let revoke: StandardRevocableToken = match token_resp.refresh_token() {
//         Some(token) => token.into(),
//         None => token_resp.access_token().into(),
//     };
// 
//     state
//         .oauth_client
//         .revoke_token(revoke)
//         .unwrap()
//         .request_async(async_http_client)
//         .await
//         .unwrap_or_default();
// 
//     Ok(StatusCode::OK)
// }

#[utoipa::path(
    post,
    path = "/api/user",
    responses(
        (status = 200, description = "Ok", body = User),
        (status = 404, description = "User not found")
    )
)]
pub async fn get_user_by_login_pass(
    State(mut state): State<AppState>,
    Json(usr): Json<UserRequest>,
) -> Result<Json<User>, MyError> {
    let user_redis: User = state
        .redis
        .json_get("user".to_owned() + &*usr.user_login.to_string(), "$")
        .await
        .unwrap_or_default();

    match user_redis.user_id {
        u if u == Uuid::default() => {
            let user = sqlx::query_as!(
                UserResponse,
                "select * from tb_user where user_login = $1",
                &usr.user_login
            )
                .fetch_one(&state.postgres)
                .await
                .unwrap();

            let res = User {
                user_id: user.user_id,
                user_login: user.user_login,
                user_password: user.user_password,
                user_email: user.user_email.unwrap_or_default(),
                user_phone: user.user_phone,
                user_access_token: user.user_access_token.unwrap(),
                user_role: sqlx::query_as!(
                    RoleResponse,
                    "select * from tb_role where role_id = $1",
                    user.user_role_id
                )
                    .fetch_one(&state.postgres)
                    .await
                    .unwrap(),
            };

            let _: () = state
                .redis
                .json_set("user".to_owned() + &*res.user_login.to_string(), "$", &res)
                .await
                .unwrap();

            Ok(Json(res))
        }
        _ => Ok(Json(user_redis)),
    }
}