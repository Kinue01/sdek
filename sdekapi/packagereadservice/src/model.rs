use redis::RedisWrite;
use redis_macros::{FromRedisValue, ToRedisArgs};
use serde::{Deserialize, Serialize};
use sqlx::types::chrono::NaiveDate;
use utoipa::ToSchema;
use uuid::Uuid;

#[derive(Clone, Debug, Deserialize, Serialize, FromRedisValue, ToRedisArgs)]
pub struct PackageType {
    pub type_id: i16,
    pub type_name: String,
    pub type_length: i32,
    pub type_width: i32,
    pub type_height: i32,
}

#[derive(Clone, Default, Debug, Deserialize, ToSchema, Serialize, FromRedisValue, ToRedisArgs)]
pub struct PackagePaytype {
    pub type_id: i16,
    pub type_name: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, FromRedisValue, ToRedisArgs)]
pub struct PackageStatus {
    pub status_id: i16,
    pub status_name: String,
}

#[derive(Clone, Default, Debug, Deserialize, Serialize)]
pub struct PackageResponse {
    pub package_uuid: Uuid,
    pub package_send_date: Option<NaiveDate>,
    pub package_receive_date: Option<NaiveDate>,
    pub package_weight: Option<bigdecimal::BigDecimal>,
    pub package_deliveryperson_id: Option<i32>,
    pub package_type_id: i16,
    pub package_status_id: i16,
    pub package_sender_id: i32,
    pub package_receiver_id: i32,
    pub package_warehouse_id: i32,
    pub package_paytype_id: i16,
    pub package_payer_id: i32
}

#[derive(Clone, Debug, Deserialize, Serialize, FromRedisValue, ToRedisArgs)]
pub struct Package {
    pub package_uuid: Uuid,
    pub package_send_date: NaiveDate,
    pub package_receive_date: NaiveDate,
    pub package_weight: bigdecimal::BigDecimal,
    pub package_deliveryperson: Option<DeliveryPerson>,
    pub package_type: PackageType,
    pub package_status: PackageStatus,
    pub package_sender: Client,
    pub package_receiver: Client,
    pub package_warehouse: Warehouse,
    pub package_paytype: PackagePaytype,
    pub package_payer: Client,
    pub package_items: Vec<PackageItem>,
}

#[derive(Clone, Default, Debug, Deserialize, Serialize)]
pub struct PackageItems {
    pub item_id: i32,
    pub package_id: Uuid,
    pub item_quantity: i32
}

#[derive(Clone, Default, Debug, Deserialize, Serialize, Ord, PartialOrd, PartialEq, Eq, Hash, FromRedisValue, ToRedisArgs)]
pub struct PackageItem {
    pub item_id: i32,
    pub item_name: String,
    pub item_description: String,
    pub item_length: bigdecimal::BigDecimal,
    pub item_width: bigdecimal::BigDecimal,
    pub item_heigth: bigdecimal::BigDecimal,
    pub item_weight: bigdecimal::BigDecimal,
}

#[derive(Clone, Debug, Serialize, Deserialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
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
pub struct PositionResponse {
    pub position_id: i16,
    pub position_name: String,
    pub position_base_pay: i32,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
pub struct Employee {
    pub employee_id: Uuid,
    pub employee_lastname: String,
    pub employee_firstname: String,
    pub employee_middlename: String,
    pub employee_position: PositionResponse,
    pub employee_user: User,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
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

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
pub struct TransportTypeResponse {
    pub type_id: i16,
    pub type_name: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
pub struct TransportStatusResponse {
    pub status_id: i16,
    pub status_name: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct TransportResponse {
    pub transport_id: i32,
    pub transport_name: String,
    pub transport_reg_number: String,
    pub transport_type_id: i16,
    pub transport_status_id: i16,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
pub struct Transport {
    pub transport_id: i32,
    pub transport_name: String,
    pub transport_reg_number: String,
    pub transport_type: TransportTypeResponse,
    pub transport_status: TransportStatusResponse,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct DeliveryPersonResponse {
    pub person_id: i32,
    pub person_lastname: String,
    pub person_firstname: String,
    pub person_middlename: String,
    pub person_user_id: Uuid,
    pub person_transport_id: i32
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
pub struct DeliveryPerson {
    pub person_id: i32,
    pub person_lastname: String,
    pub person_firstname: String,
    pub person_middlename: String,
    pub person_user: User,
    pub person_transport: Transport
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
pub struct WarehouseTypeResponse {
    pub type_id: i16,
    pub type_name: String,
    pub type_small_quantity: i32,
    pub type_med_quantity: i32,
    pub type_huge_quantity: i32,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct WarehouseResponse {
    pub warehouse_id: i32,
    pub warehouse_name: String,
    pub warehouse_address: String,
    pub warehouse_type_id: i16
}

#[derive(Clone, Debug, Deserialize, Serialize, FromRedisValue, ToRedisArgs)]
pub struct Warehouse {
    pub warehouse_id: i32,
    pub warehouse_name: String,
    pub warehouse_address: String,
    pub warehouse_type: WarehouseTypeResponse
}
