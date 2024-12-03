use ::serde::{Deserialize, Serialize};
use utoipa::ToSchema;
use uuid::Uuid;

#[derive(Clone, Debug, Serialize, Deserialize, ToSchema, Default)]
pub struct RoleResponse {
    pub role_id: i16,
    pub role_name: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct User {
    pub user_id: Uuid,
    pub user_login: String,
    pub user_password: String,
    pub user_email: String,
    pub user_phone: String,
    pub user_access_token: String,
    pub user_role: RoleResponse,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize, ToSchema)]
pub struct Message {
    pub user: Uuid,
    pub msg_type: u32,
    pub title: String,
    pub body: String,
}
