use ::serde::{Deserialize, Serialize};
use redis_macros::{FromRedisValue, ToRedisArgs};
use utoipa::ToSchema;
use uuid::Uuid;

#[derive(Clone, Debug, Serialize, Deserialize, ToSchema, Default)]
pub struct RoleResponse {
    pub role_id: i16,
    pub role_name: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, Default, ToSchema, FromRedisValue, ToRedisArgs)]
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

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct UserRequest {
    pub user_login: String,
    pub user_password: String
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, ToSchema)]
pub struct CodeResponse {
    pub code: String,
    pub state: String,
}