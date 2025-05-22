use redis_macros::{FromRedisValue, ToRedisArgs};
use ::serde::{Deserialize, Serialize};
use sqlx::types::*;
use utoipa::ToSchema;

#[derive(Clone, Debug, Serialize, Deserialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
pub struct RoleResponse {
    pub role_id: i16,
    pub role_name: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
pub struct UserResponse {
    pub user_id: Uuid,
    pub user_login: String,
    pub user_password: String,
    pub user_email: Option<String>,
    pub user_phone: String,
    pub user_access_token: Option<String>,
    pub user_role_id: i16,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
pub struct User {
    pub user_id: Uuid,
    pub user_login: String,
    pub user_password: String,
    pub user_email: String,
    pub user_phone: String,
    pub user_access_token: String,
    pub user_role: RoleResponse,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
pub struct ClientResponse {
    pub client_id: i32,
    pub client_lastname: String,
    pub client_firstname: String,
    pub client_middlename: String,
    pub client_user_id: Uuid,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
pub struct Client {
    pub client_id: i32,
    pub client_lastname: String,
    pub client_firstname: String,
    pub client_middlename: String,
    pub client_user: User,
}
