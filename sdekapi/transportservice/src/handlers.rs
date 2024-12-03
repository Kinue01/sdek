use axum::extract::{State, WebSocketUpgrade};
use axum::extract::ws::WebSocket;
use axum::http::StatusCode;
use axum::Json;
use axum::response::Response;
use eventstore::{Client, EventData};

use crate::error::MyError;
use crate::model::{Transport, TransportTypeResponse};

pub async fn add_transport_type(
    State(state): State<Client>,
    Json(t_type): Json<TransportTypeResponse>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("transport_type_add", t_type).unwrap();
    let _ = state
        .append_to_stream("transport_type", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::CREATED)
}

pub async fn update_transport_type(
    State(state): State<Client>,
    Json(t_type): Json<TransportTypeResponse>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("transport_type_update", t_type).unwrap();
    let _ = state
        .append_to_stream("transport_type", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

pub async fn delete_transport_type(
    State(state): State<Client>,
    Json(t_type): Json<TransportTypeResponse>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("transport_type_delete", t_type).unwrap();
    let _ = state
        .append_to_stream("transport_type", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

pub async fn add_transport(
    State(state): State<Client>,
    Json(transport): Json<Transport>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("transport_add", transport).unwrap();
    let _ = state
        .append_to_stream("transport", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::CREATED)
}

pub async fn update_transport(
    State(state): State<Client>,
    Json(transport): Json<Transport>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("transport_update", transport).unwrap();
    let _ = state
        .append_to_stream("transport", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

pub async fn delete_transport(
    State(state): State<Client>,
    Json(transport): Json<Transport>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("transport_delete", transport).unwrap();
    let _ = state
        .append_to_stream("transport", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

pub async fn ws_transport_update(State(state): State<Client>, ws: WebSocketUpgrade) -> Response {
    ws.on_upgrade(|socket| handle_socket(socket, state))
}

async fn handle_socket(mut socket: WebSocket, mut state: Client) {
    loop {
        let msg = socket.recv().await.unwrap().unwrap();
        let event = EventData::binary("transport_geo_changed", msg.into_data().into());
        let _ = state.append_to_stream("transport_geo", &Default::default(), event);
    }
}
