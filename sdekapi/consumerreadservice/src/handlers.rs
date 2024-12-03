use std::clone::Clone;
use std::ptr::null;
use axum::extract::{Query, State};
use axum::Json;
use derive_more::Display;
use futures::StreamExt;
use redis::{AsyncCommands, JsonAsyncCommands};
use serde::Deserialize;
use utoipa::IntoParams;
use uuid::Uuid;

use crate::AppState;
use crate::error::MyError;
use crate::error::MyError::RDbError;
use crate::model::*;

#[utoipa::path(
    get,
    path = "/api/clients",
    responses(
        (status = 200, description = "Success", body = Vec < Client >),
        (status = 404, description = "Clients not found")
    )
)]
pub async fn get_clients(State(mut state): State<AppState>) -> Result<Json<Vec<Client>>, MyError> {
    let clients_redis: Vec<Client> = state.redis.json_get("clients", "$").await.unwrap_or_default();

    match clients_redis.is_empty() {
        false => Ok(Json(clients_redis)),
        true => {
            let clients = sqlx::query_as!(ClientResponse, "select * from tb_client")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let res = futures::stream::iter(clients)
                .map(|x| async {
                    let postgres = state.postgres.clone();

                    tokio::spawn(async move {
                        let user_response = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &x.client_user_id)
                            .fetch_one(&postgres)
                            .await
                            .map_err(MyError::DBError).unwrap();

                        Client {
                            client_id: x.clone().client_id,
                            client_lastname: x.client_lastname,
                            client_firstname: x.client_firstname,
                            client_middlename: x.client_middlename,
                            client_user: User {
                                user_id: user_response.user_id,
                                user_login: user_response.user_login,
                                user_password: user_response.user_password,
                                user_email: user_response.user_email.unwrap(),
                                user_phone: user_response.user_phone,
                                user_access_token: user_response.user_access_token.unwrap(),
                                user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &user_response.user_role_id)
                                    .fetch_one(&postgres)
                                    .await
                                    .map_err(MyError::DBError).unwrap(),
                            }
                        }
                    })
                    .await
                    .unwrap_or_default()
                })
                .buffer_unordered(10)
                .collect::<Vec<_>>()
                .await;

            let _: () = state.redis.json_set("clients", "$", &res).await.unwrap();

            Ok(Json(res))
        }
    }
}

#[derive(Deserialize, IntoParams, Display)]
pub struct ClientSearchQuery {
    id: i32,
}

#[utoipa::path(
    get,
    path = "/api/client",
    responses(
        (status = 200, description = "Ok", body = Client),
        (status = 404, description = "Client not found")
    ),
    params(
        ClientSearchQuery
    )
)]
pub async fn get_client_by_id(
    State(mut state): State<AppState>,
    id: Query<ClientSearchQuery>,
) -> Result<Json<Client>, MyError> {
    let client_redis: Client = state
        .redis
        .json_get("client".to_owned() + &*id.0.to_string(), "$")
        .await
        .unwrap_or_default();

    match client_redis.client_id {
        0 => {
            let client = sqlx::query_as!(
                ClientResponse,
                "select * from tb_client where client_id = $1",
                &id.0.id
            )
            .fetch_one(&state.postgres)
            .await
            .map_err(MyError::DBError)?;
            
            let user_resp = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &client.client_user_id)
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let res = Client {
                client_id: client.client_id,
                client_lastname: client.client_lastname,
                client_firstname: client.client_firstname,
                client_middlename: client.client_middlename,
                client_user: User {
                    user_id: user_resp.user_id,
                    user_login: user_resp.user_login,
                    user_password: user_resp.user_password,
                    user_email: user_resp.user_email.unwrap(),
                    user_phone: user_resp.user_phone,
                    user_access_token: user_resp.user_access_token.unwrap(),
                    user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", user_resp.user_role_id)
                        .fetch_one(&state.postgres)
                        .await
                        .map_err(MyError::DBError)?,
                },
            };

            let _: () = state
                .redis
                .json_set("client".to_owned() + &*id.0.to_string(), "$", &res)
                .await
                .unwrap();

            Ok(Json(res))
        }
        _ => Ok(Json(client_redis)),
    }
}

#[derive(Deserialize, Display)]
pub struct ClientUserParams {
    uuid: Uuid
}

pub async fn get_client_by_user_id(
    State(mut state): State<AppState>,
    uuid: Query<ClientUserParams>,
) -> Result<Json<Client>, MyError> {
    let client = sqlx::query_as!(
        ClientResponse,
        "select * from tb_client where client_user_id = $1",
        uuid.0.uuid
    )
    .fetch_one(&state.postgres)
    .await
    .map_err(MyError::DBError)?;

    let client_redis = state
        .redis
        .get("client".to_owned() + &*client.client_id.to_string())
        .await.map_err(RDbError);

    match !client_redis.is_ok() {
        true => {
            let user_resp = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &client.client_user_id)
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?;
            
            let res = Client {
                client_id: client.client_id,
                client_lastname: client.client_lastname,
                client_firstname: client.client_firstname,
                client_middlename: client.client_middlename,
                client_user: User {
                    user_id: user_resp.user_id,
                    user_login: user_resp.user_login,
                    user_password: user_resp.user_password,
                    user_email: user_resp.user_email.unwrap(),
                    user_phone: user_resp.user_phone,
                    user_access_token: user_resp.user_access_token.unwrap(),
                    user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", user_resp.user_role_id)
                        .fetch_one(&state.postgres)
                        .await
                        .map_err(MyError::DBError)?,
                },
            };

            let _: () = state
                .redis
                .set("client".to_owned() + &*client.client_id.to_string(), &res)
                .await
                .unwrap();

            Ok(Json(res))
        }
        false => Ok(Json(client_redis.unwrap_or_default())),
    }
}

pub async fn update_db(State(mut state): State<AppState>) {
    let mut stream = state
        .event_client
        .subscribe_to_stream("client", &Default::default())
        .await;
    
    loop {
        let event = stream.next().await.unwrap();
        let ev = event.get_original_event().as_json::<Client>().unwrap();
        let _: () = state.redis.json_del("clients", "$").await.unwrap();
        match event.event.unwrap().event_type.as_str() {
            "client_add" => {
                let _ = sqlx::query!("insert into tb_client (client_lastname, client_firstname, client_middlename, client_user_id) values ($1, $2, $3, $4)", &ev.client_lastname, &ev.client_firstname, &ev.client_middlename, &ev.client_user.user_id)
                    .execute(&state.postgres).await.map_err(MyError::DBError).unwrap();
            }
            "client_update" => {
                let _ = sqlx::query!("update tb_client set client_lastname = $1, client_firstname = $2, client_middlename = $3 where client_id = $4", &ev.client_lastname, &ev.client_firstname, &ev.client_middlename, &ev.client_id)
                    .execute(&state.postgres).await.map_err(MyError::DBError).unwrap();

                let _: () = state
                    .redis
                    .json_del("client".to_owned() + &*ev.client_id.to_string(), "$")
                    .await
                    .unwrap();
            }
            "client_delete" => {
                let _ = sqlx::query!("delete from tb_client where client_id = $1", &ev.client_id)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let _: () = state
                    .redis
                    .json_del("client".to_owned() + &*ev.client_id.to_string(), "$")
                    .await
                    .unwrap();
            }
            _ => {}
        }
    }
}
