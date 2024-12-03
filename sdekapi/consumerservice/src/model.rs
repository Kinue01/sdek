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

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct Client {
    pub client_id: i32,
    pub client_lastname: String,
    pub client_firstname: String,
    pub client_middlename: String,
    pub client_user: User,
}
