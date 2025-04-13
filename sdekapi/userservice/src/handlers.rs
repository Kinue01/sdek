use axum::extract::{Json, State};
use axum::http::StatusCode;
use eventstore::EventData;

use crate::{AppState, model::*};
use crate::error::MyError;

pub async fn add_user(
    State(state): State<AppState>,
    Json(user): Json<User>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("user_add", &user).unwrap();
    let _ = state
        .event_client
        .append_to_stream("user", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::CREATED)
}

pub async fn update_user(
    State(state): State<AppState>,
    Json(user): Json<User>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("user_update", &user).unwrap();
    let _ = state
        .event_client
        .append_to_stream("user", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

pub async fn delete_user(
    State(state): State<AppState>,
    Json(user): Json<User>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("user_delete", &user).unwrap();
    let _ = state
        .event_client
        .append_to_stream("user", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

#[utoipa::path(
    post,
    path = "/api/msg",
    request_body(content = Message, description = "Message"),
    responses(
        (status = 201, description = "Message sent"),
        (status = 500, description = "Can`t send message")
    )
)]
pub async fn send_msg_kafka(
    State(state): State<AppState>,
    Json(msg): Json<Message>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("notification_send", &msg).unwrap();
    let _ = state
        .event_client
        .append_to_stream("notification", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}
