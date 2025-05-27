use axum::extract::{Json, State};
use redis::JsonAsyncCommands;
use uuid::Uuid;

use crate::error::MyError;
use crate::{model::*, AppState};

#[utoipa::path(
    post,
    path = "/api/user",
    responses(
        (status = 200, description = "Ok", body = User),
        (status = 404, description = "User not found")
    )
)]
pub async fn get_user_by_login_pass(
    State(state): State<AppState>,
    Json(usr): Json<UserRequest>,
) -> Result<Json<User>, MyError> {
    let user = sqlx::query_as!(
                UserResponse,
                "select * from tb_user where user_login = $1",
                &usr.user_login
            )
        .fetch_one(&state.postgres)
        .await
        .unwrap();

    Ok(
        Json(
            User {
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
            }
        )
    )
}