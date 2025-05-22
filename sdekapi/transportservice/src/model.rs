use serde::{Deserialize, Serialize};
use utoipa::ToSchema;

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
pub struct Transport {
    pub transport_id: i32,
    pub transport_name: String,
    pub transport_reg_number: String,
    pub transport_type: TransportTypeResponse,
    pub transport_status: TransportStatusResponse,
}
