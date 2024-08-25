use redis_macros::{FromRedisValue, ToRedisArgs};
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;
use uuid::Uuid;

#[derive(Clone, Default, Debug, Deserialize, ToSchema, Serialize, FromRedisValue, ToRedisArgs)]
pub struct PackageType {
    pub type_id: i16,
    pub type_name: String,
    pub type_length: i32,
    pub type_width: i32,
    pub type_height: i32,
    pub type_weight: i32,
}

#[derive(Clone, Default, Debug, Deserialize, Serialize, ToSchema, FromRedisValue, ToRedisArgs)]
pub struct PackageStatus {
    pub status_id: i16,
    pub status_name: String,
}

#[derive(Clone, Default, Debug, Deserialize, Serialize, ToSchema)]
pub struct PackageResponse {
    pub package_uuid: Uuid,
    pub package_transport_id: i32,
    pub package_type_id: i16,
    pub package_status_id: i16,
    pub package_sender_id: i32,
}

#[derive(Clone, Default, Debug, Deserialize, Serialize, ToSchema, FromRedisValue, ToRedisArgs)]
pub struct Package {
    pub package_uuid: Uuid,
    pub package_transport: Transport,
    pub package_type: PackageType,
    pub package_status: PackageStatus,
    pub package_sender: Client,
    pub package_items: Vec<PackageItem>,
}

#[derive(Clone, Default, Debug, Deserialize, Serialize, ToSchema)]
pub struct PackageItem {
    pub package_id: Uuid,
    pub item_name: String,
    pub item_length: bigdecimal::BigDecimal,
    pub item_width: bigdecimal::BigDecimal,
    pub item_heigth: bigdecimal::BigDecimal,
    pub item_weight: bigdecimal::BigDecimal,
}

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
    pub user_role: RoleResponse,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct PositionResponse {
    pub position_id: i16,
    pub position_name: String,
    pub position_base_pay: i32,
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

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct TransportTypeResponse {
    pub type_id: i16,
    pub type_name: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct Transport {
    pub transport_id: i32,
    pub transport_name: String,
    pub transport_type: TransportTypeResponse,
    pub transport_driver: Employee,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct Client {
    pub client_id: i32,
    pub client_lastname: String,
    pub client_firstname: String,
    pub client_middlename: String,
    pub client_user: User,
}
