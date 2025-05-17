use chrono::NaiveDate;
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;
use uuid::Uuid;

#[derive(Clone, Default, Debug, Deserialize, ToSchema, Serialize)]
pub struct PackageType {
    pub type_id: i16,
    pub type_name: String,
    pub type_length: i32,
    pub type_width: i32,
    pub type_height: i32,
}

#[derive(Clone, Default, Debug, Deserialize, Serialize, ToSchema)]
pub struct PackageStatus {
    pub status_id: i16,
    pub status_name: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
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

#[derive(Clone, Default, Debug, Deserialize, ToSchema, Serialize)]
pub struct PackagePaytype {
    pub type_id: i16,
    pub type_name: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
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

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct Warehouse {
    pub warehouse_id: i32,
    pub warehouse_name: String,
    pub warehouse_address: String,
    pub warehouse_type: WarehouseTypeResponse
}

#[derive(Clone, Default, Debug, Deserialize, Serialize, ToSchema)]
pub struct PackageItem {
    pub item_id: i32,
    pub item_name: String,
    pub item_description: String,
    pub item_length: f32,
    pub item_width: f32,
    pub item_heigth: f32,
    pub item_weight: f32,
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
    pub user_access_token: String,
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
pub struct Client {
    pub client_id: i32,
    pub client_lastname: String,
    pub client_firstname: String,
    pub client_middlename: String,
    pub client_user: User,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct TransportTypeResponse {
    pub type_id: i16,
    pub type_name: String,
}

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
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

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
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

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default)]
pub struct DeliveryPerson {
    pub person_id: i32,
    pub person_lastname: String,
    pub person_firstname: String,
    pub person_middlename: String,
    pub person_user: User,
    pub person_transport: Transport
}