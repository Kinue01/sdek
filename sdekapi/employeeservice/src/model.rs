use serde::{Deserialize, Serialize};
use utoipa::ToSchema;
use uuid::Uuid;

#[derive(Clone, Debug, Serialize, Deserialize, ToSchema, Default)]
pub struct RoleResponse {
    pub role_id: i16,
    pub role_name: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, Default, ToSchema)]
pub struct UserResponse {
    pub user_id: Uuid,
    pub user_login: String,
    pub user_password: String,
    pub user_email: Option<String>,
    pub user_phone: String,
    pub user_access_token: Option<String>,
    pub user_role_id: i16,
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
pub struct PositionResponse {
    pub position_id: i16,
    pub position_name: String,
    pub position_base_pay: i32,
}

#[derive(Clone, Debug, Deserialize, Serialize, Default, ToSchema)]
pub struct EmployeeResponse {
    pub employee_id: Uuid,
    pub employee_lastname: String,
    pub employee_firstname: String,
    pub employee_middlename: String,
    pub employee_position_id: i16,
    pub employee_user_id: Uuid,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct Employee {
    pub employee_id: Uuid,
    pub employee_lastname: String,
    pub employee_firstname: String,
    pub employee_middlename: String,
    pub employee_position: PositionResponse,
    pub employee_user: User,
}
