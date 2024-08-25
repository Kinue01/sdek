use axum::extract::WebSocketUpgrade;
use axum::extract::ws::WebSocket;
use axum::response::Response;
use eventstore::{Client, ReadStream, ReadStreamOptions};

use crate::model::Message;

pub async fn handler(ws: WebSocketUpgrade) -> Response {
    let client = Client::new("esdb://admin:@localhost:2113".parse().unwrap_or_default()).unwrap();
    let stream = client
        .read_stream("notification", &ReadStreamOptions::default())
        .await
        .unwrap();

    ws.on_upgrade(|socket| handle_socket(socket, stream))
}

async fn handle_socket(mut socket: WebSocket, mut state: ReadStream) {
    loop {
        let ev = state.next().await.unwrap().unwrap();

        let event = ev
            .get_original_event()
            .as_json::<Message>()
            .unwrap_or_default();

        let res = bincode::serialize(&event).unwrap();

        if socket
            .send(axum::extract::ws::Message::from(res))
            .await
            .is_err()
        {
            return;
        }
    }
}
