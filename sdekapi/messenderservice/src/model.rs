use bincode::Encode;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Clone, Debug, Default, Deserialize, Serialize)]
pub struct Message {
    pub user: Uuid,
    pub msg_type: u32,
    pub title: String,
    pub body: String,
}
