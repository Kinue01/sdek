use axum::extract::State;
use axum::http::StatusCode;
use axum::Json;
use eventstore::EventData;

use crate::error::MyError;
use crate::model::Client;

#[utoipa::path(
    post,
    path = "/api/client",
    request_body(content = Json<Client>, description = "Client"),
    responses(
        (status =  201, description = "Client created"),
        (status = 500, description = "Can`t create client")
    )
)]
pub async fn add_client(
    State(state): State<eventstore::Client>,
    Json(client): Json<Client>,
) -> Result<StatusCode, MyError> {
    let client_event = EventData::json("client_add", &client).unwrap();
    let user_event = EventData::json("user_add", client.client_user).unwrap();

    let _ = state
        .append_to_stream("user", &Default::default(), user_event)
        .await
        .unwrap();
    let _ = state
        .append_to_stream("client", &Default::default(), client_event)
        .await
        .unwrap();

    Ok(StatusCode::CREATED)
}

#[utoipa::path(
    patch,
    path = "/api/client",
    request_body(content = Json<Client>, description = "Client"),
    responses(
        (status = 200, description = "Client updated"),
        (status = 500, description = "Can`t update client")
    )
)]
pub async fn update_client(
    State(state): State<eventstore::Client>,
    Json(client): Json<Client>,
) -> Result<StatusCode, MyError> {
    let client_event = EventData::json("client_update", &client).unwrap();
    let user_event = EventData::json("user_update", client.client_user).unwrap();

    let _ = state
        .append_to_stream("user", &Default::default(), user_event)
        .await
        .unwrap();
    let _ = state
        .append_to_stream("client", &Default::default(), client_event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

#[utoipa::path(
    delete,
    path = "/api/client",
    request_body(content = Json<Client>, description = "Client"),
    responses(
        (status = 200, description = "Client deleted"),
        (status = 500, description = "Can`t delete client")
    )
)]
pub async fn delete_client(
    State(state): State<eventstore::Client>,
    Json(client): Json<Client>,
) -> Result<StatusCode, MyError> {
    let client_event = EventData::json("client_delete", &client).unwrap();
    let user_event = EventData::json("user_delete", client.client_user).unwrap();

    let _ = state
        .append_to_stream("client", &Default::default(), client_event)
        .await
        .unwrap();
    let _ = state
        .append_to_stream("user", &Default::default(), user_event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}
