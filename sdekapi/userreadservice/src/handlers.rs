use axum::extract::{Query, State};
use axum::Json;
use futures::StreamExt;
use redis::{AsyncCommands, JsonAsyncCommands};
use serde::Deserialize;
use utoipa::IntoParams;
use uuid::Uuid;

use crate::error::MyError;
use crate::model::{RoleResponse, User, UserResponse};
use crate::AppState;

#[utoipa::path(
    get,
    path = "/api/roles",
    responses(
        (status = 200, description = "Success", body = Vec < RoleResponse >),
        (status = 404, description = "Roles not found")
    )
)]
pub async fn get_roles(
    State(state): State<AppState>,
) -> Result<Json<Vec<RoleResponse>>, MyError> {
    let roles = sqlx::query_as!(RoleResponse, "select * from tb_role")
        .fetch_all(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    Ok(Json(roles))
}

#[derive(Deserialize, IntoParams)]
pub struct RoleSearchQuery {
    id: i16,
}

#[utoipa::path(
    get,
    path = "/api/role",
    responses(
        (status = 200, description = "Success", body = RoleResponse),
        (status = 404, description = "Role not found")
    ),
    params(
        RoleSearchQuery
    )
)]
pub async fn get_role_by_id(
    State(state): State<AppState>,
    id: Query<RoleSearchQuery>,
) -> Result<Json<RoleResponse>, MyError> {
    let role = sqlx::query_as!(
                RoleResponse,
                "select * from tb_role where role_id = $1",
                id.id
            )
        .fetch_one(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    Ok(Json(role))
}

#[utoipa::path(
    get,
    path = "/api/users",
    responses(
        (status = 200, description = "Success", body = Vec < User >),
        (status = 404, description = "Users not found")
    )
)]
pub async fn get_users(State(state): State<AppState>) -> Result<Json<Vec<User>>, MyError> {
    let users = sqlx::query_as!(UserResponse, "select * from tb_user")
        .fetch_all(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    let res = futures::stream::iter(users)
        .map(|x| async {
            let postgres = state.postgres.clone();

            tokio::spawn(async move {
                User {
                    user_id: x.clone().user_id,
                    user_login: x.user_login,
                    user_password: x.user_password,
                    user_email: x.user_email.unwrap_or_default(),
                    user_phone: x.user_phone,
                    user_access_token: x.user_access_token.unwrap(),
                    user_role: sqlx::query_as!(
                                RoleResponse,
                                "select * from tb_role where role_id = $1",
                                &x.user_role_id
                            )
                        .fetch_one(&postgres)
                        .await
                        .map_err(MyError::DBError)
                        .unwrap(),
                }
            })
                .await
                .unwrap_or_default()
        })
        .buffer_unordered(24)
        .collect::<Vec<_>>()
        .await;

    Ok(Json(res))
}

#[derive(Deserialize, IntoParams)]
pub struct UserSearchQuery {
    uuid: Uuid,
}

#[utoipa::path(
    get,
    path = "/api/user",
    responses(
        (status = 200, description = "Ok", body = User),
        (status = 404, description = "User not found")
    ),
    params(
        UserSearchQuery
    )
)]
pub async fn get_user_by_id(
    State(state): State<AppState>,
    uuid: Query<UserSearchQuery>,
) -> Result<Json<User>, MyError> {
    let user = sqlx::query_as!(
                UserResponse,
                "select * from tb_user where user_id = $1",
                &uuid.uuid
            )
        .fetch_one(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

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
                    .map_err(MyError::DBError)?,
            }
        )
    )
}

pub async fn update_db(State(state): State<AppState>) {
    let mut stream = state
        .event_client
        .subscribe_to_stream("user", &Default::default())
        .await;
    
    loop {
        let event = stream.next().await.unwrap();
        let ev = event.get_original_event().as_json::<User>().unwrap();
        
        match event.event.unwrap().event_type.as_str() {
            "user_add" => {
                let _ = sqlx::query!("insert into tb_user (user_id, user_login, user_password, user_email, user_phone, user_access_token, user_role_id) values ($1, $2, $3, $4, $5, $6, $7)", &ev.user_id, &ev.user_login, &ev.user_password, &ev.user_email, &ev.user_phone, &ev.user_access_token, &ev.user_role.role_id)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();
            }
            "user_update" => {
                let _ = sqlx::query!("update tb_user set user_login = $1, user_password = $2, user_email = $3, user_phone = $4, user_access_token = $5, user_role_id = $6 where user_id = $7", &ev.user_login, &ev.user_password, &ev.user_email, &ev.user_phone, &ev.user_access_token, &ev.user_role.role_id, &ev.user_id)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();
            }
            "user_delete" => {
                let _ = sqlx::query!("delete from tb_user where user_id = $1", &ev.user_id)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();
            }
            _ => {}
        }
    }
}
