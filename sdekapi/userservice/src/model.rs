use ::serde::{Deserialize, Serialize};
use sqlx::prelude::*;
use sqlx::types::*;
use utoipa::ToSchema;

#[derive(Clone, Debug, FromRow, Deserialize, Serialize, ToSchema)]
pub struct RoleResponse {
    pub role_id: i32,
    pub role_name: String,
}

#[derive(Clone, Debug, FromRow, Deserialize, Serialize)]
pub struct UserResponse {
    pub user_id: Uuid,
    pub user_login: String,
    pub user_password: String,
    pub user_role_id: i32,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema)]
pub struct User {
    pub user_id: Uuid,
    pub user_login: String,
    pub user_password: String,
    pub user_role: RoleResponse,
}

#[derive(Clone, Debug, FromRow, Deserialize, Serialize, ToSchema)]
pub struct PositionResponse {
    pub position_id: i32,
    pub position_name: String,
    pub position_base_pay: i32,
}

#[derive(Clone, Debug, FromRow, Deserialize, Serialize)]
pub struct ClientResponse {
    pub client_id: i32,
    pub client_lastname: String,
    pub client_firstname: String,
    pub client_middlename: String,
    pub client_user_id: Uuid,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema)]
pub struct Client {
    pub client_id: i32,
    pub client_lastname: String,
    pub client_firstname: String,
    pub client_middlename: String,
    pub client_user: User,
}

#[derive(Clone, Debug, FromRow, Deserialize, Serialize)]
pub struct EmployeeResponse {
    pub employee_id: Uuid,
    pub employee_lastname: String,
    pub employee_firstname: String,
    pub employee_middlename: String,
    pub employee_position_id: i32,
    pub employee_user_id: Uuid,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema)]
pub struct Employee {
    pub employee_id: Uuid,
    pub employee_lastname: String,
    pub employee_firstname: String,
    pub employee_middlename: String,
    pub employee_position: PositionResponse,
    pub employee_user: User,
}