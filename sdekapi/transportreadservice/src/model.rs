use bincode::{Decode, Encode};
use redis_macros::{FromRedisValue, ToRedisArgs};
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;
use uuid::Uuid;

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

#[derive(Clone, Debug, Deserialize, Serialize, ToSchema, Default, FromRedisValue, ToRedisArgs)]
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

#[derive(Clone, Debug, ToSchema, Default, Deserialize, Encode, Decode, PartialEq)]
pub struct TransportMongo {
    pub transport_id: i32,
    pub lat: f32,
    pub lon: f32,
}
