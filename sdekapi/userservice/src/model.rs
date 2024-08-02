use ::serde::{Deserialize, Serialize};
use sqlx::prelude::*;
use sqlx::types::*;
use utoipa::ToSchema;

#[derive(Clone, Debug, FromRow, Serialize, Deserialize, ToSchema, Default)]
pub struct RoleResponse {
    pub role_id: i16,
    pub role_name: String,
}

// impl FromRedisValue for RoleResponse {
//     fn from_redis_value(v: &Value) -> RedisResult<Self> {
//         let v: String = from_redis_value(v)?;
//         if let Some((role_id, role_name)) = v.split_once('-') {
//             if let Ok(role_id) = role_id.parse() {
//                 Ok(RoleResponse {
//                     role_id,
//                     role_name: role_name.to_string(),
//                 })
//             } else {
//                 Err((ErrorKind::TypeError, "bad id").into())
//             }
//         } else {
//             Err((ErrorKind::TypeError, "bad name").into())
//         }
//     }
// }

#[derive(Clone, Debug, FromRow, Deserialize, Serialize, Default, ToSchema)]
pub struct UserResponse {
    pub user_id: Uuid,
    pub user_login: String,
    pub user_password: String,
    pub user_role_id: i16,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct User {
    pub user_id: Uuid,
    pub user_login: String,
    pub user_password: String,
    pub user_role: RoleResponse,
}

#[derive(Clone, Debug, FromRow, Deserialize, Serialize, ToSchema, Default)]
pub struct PositionResponse {
    pub position_id: i16,
    pub position_name: String,
    pub position_base_pay: i32,
}

#[derive(Clone, Debug, FromRow, Deserialize, Serialize, Default, ToSchema)]
pub struct ClientResponse {
    pub client_id: i32,
    pub client_lastname: String,
    pub client_firstname: String,
    pub client_middlename: String,
    pub client_user_id: Uuid,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct Client {
    pub client_id: i32,
    pub client_lastname: String,
    pub client_firstname: String,
    pub client_middlename: String,
    pub client_user: User,
}

#[derive(Clone, Debug, FromRow, Deserialize, Serialize, Default, ToSchema)]
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
