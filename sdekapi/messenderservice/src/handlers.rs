use axum::extract::WebSocketUpgrade;
use axum::extract::ws::WebSocket;
use axum::response::Response;
use eventstore::{Client, Subscription};
use crate::model;

pub async fn handler(ws: WebSocketUpgrade) -> Response {
    let client = Client::new("esdb://admin:@eventstore:2113?tls=false".parse().unwrap_or_default()).unwrap();
    let stream = client
        .subscribe_to_stream("notification", &Default::default())
        .await;

    ws.on_upgrade(|socket| handle_socket(socket, stream))
}

async fn handle_socket(mut socket: WebSocket, mut state: Subscription) {
    loop {
        let ev = state.next().await.unwrap();

        let event = ev
            .get_original_event()
            .as_json::<model::Message>()
            .unwrap_or_default();

        if socket
            .send(axum::extract::ws::Message::text(serde_json::to_string(&event).unwrap()))
            .await
            .is_err()
        {
            return;
        }
    }
}
