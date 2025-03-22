use axum::extract::ws::{Message, WebSocket};
use axum::extract::{Query, State, WebSocketUpgrade};
use axum::response::Response;
use axum::Json;
use futures::StreamExt;
use mongodb::bson::{doc, Document};
use mongodb::Collection;
use redis::{AsyncCommands, JsonAsyncCommands};

use crate::AppState;
use crate::error::MyError;
use crate::model::*;

pub async fn get_transport_types(
    State(mut state): State<AppState>,
) -> Result<Json<Vec<TransportTypeResponse>>, MyError> {
    let types_redis: Vec<TransportTypeResponse> =
        state.redis.json_get("trans_types", "$").await.unwrap_or_default();

    match types_redis.is_empty() {
        true => {
            let res = sqlx::query_as!(TransportTypeResponse, "select * from tb_transport_type")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let _: () = state.redis.json_set("trans_types", "$", &res).await.unwrap();

            Ok(Json(res))
        }
        false => Ok(Json(types_redis)),
    }
}

pub async fn get_transport_type_by_id(
    State(mut state): State<AppState>,
    id: Query<i16>,
) -> Result<Json<TransportTypeResponse>, MyError> {
    let type_redis: TransportTypeResponse = state
        .redis
        .json_get("trans_type".to_string() + &*id.0.to_string(), "$")
        .await
        .unwrap_or_default();

    match type_redis.type_id == 0 {
        true => {
            let res = sqlx::query_as!(
                TransportTypeResponse,
                "select * from tb_transport_type where type_id = $1",
                id.0
            )
            .fetch_one(&state.postgres)
            .await
            .map_err(MyError::DBError)?;

            let _: () = state
                .redis
                .json_set("trans_type".to_string() + &*id.0.to_string(), "$", &res)
                .await
                .unwrap();

            Ok(Json(res))
        }
        false => Ok(Json(type_redis)),
    }
}

pub async fn get_transport(
    State(mut state): State<AppState>,
) -> Result<Json<Vec<Transport>>, MyError> {
    let trans_redis: Vec<Transport> = state.redis.json_get("trans", "$").await.unwrap_or_default();

    match trans_redis.is_empty() {
        true => {
            let trans = sqlx::query_as!(TransportResponse, "select * from tb_transport")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let stream = futures::stream::iter(trans)
                .map(|x| async {
                    let postgres = state.postgres.clone();

                    tokio::spawn(async move {
                        Transport {
                            transport_id: x.transport_id,
                            transport_name: x.clone().transport_name,
                            transport_reg_number: x.transport_reg_number,
                            transport_type: sqlx::query_as!(
                                TransportTypeResponse,
                                "select * from tb_transport_type where type_id = $1",
                                x.transport_type_id
                            )
                            .fetch_one(&postgres)
                            .await
                            .unwrap_or_default(),
                            transport_status: sqlx::query_as!(TransportStatusResponse, "select * from tb_transport_status where status_id = $1", &x.transport_status_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                        }
                    })
                    .await
                    .unwrap_or_default()
                })
                .buffer_unordered(10)
                .collect::<Vec<_>>()
                .await;

            let _: () = state.redis.json_set("trans", "$", &stream).await.unwrap();

            Ok(Json(stream))
        }
        false => Ok(Json(trans_redis)),
    }
}

pub async fn get_transport_by_id(
    State(mut state): State<AppState>,
    id: Query<i32>,
) -> Result<Json<Transport>, MyError> {
    let trans_redis: Transport = state
        .redis
        .json_get("trans".to_owned() + &*id.0.to_string(), "$")
        .await
        .unwrap_or_default();

    match trans_redis.transport_id == 0 {
        true => {
            let trans = sqlx::query_as!(
                TransportResponse,
                "select * from tb_transport where transport_id = $1",
                id.0
            )
            .fetch_one(&state.postgres)
            .await
            .map_err(MyError::DBError)?;

            let res = Transport {
                transport_id: trans.transport_id,
                transport_name: trans.transport_name,
                transport_reg_number: trans.transport_reg_number,
                transport_type: sqlx::query_as!(
                    TransportTypeResponse,
                    "select * from tb_transport_type where type_id = $1",
                    trans.transport_type_id
                )
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?,
                transport_status: sqlx::query_as!(TransportStatusResponse, "select * from tb_transport_status where status_id = $1", &trans.transport_status_id)
                    .fetch_one(&state.postgres)
                    .await
                    .map_err(MyError::DBError)?,
            };

            let _: () = state
                .redis
                .json_set("trans".to_owned() + &*id.0.to_string(), "$", &res)
                .await
                .unwrap();

            Ok(Json(res))
        }
        false => Ok(Json(trans_redis)),
    }
}

pub async fn get_transport_by_driver_id(
    State(state): State<AppState>,
    id: Query<i32>,
) -> Result<Json<Transport>, MyError> {
    let trans = sqlx::query!(
        "select person_transport_id from tb_fdelivery_person where person_id = $1",
        id.0
    )
    .fetch_one(&state.postgres)
    .await
    .map_err(MyError::DBError)?;

    let res = get_transport_by_id(State(state), Query(trans.person_transport_id))
        .await
        .unwrap_or_default().0;

    Ok(Json(res))
}

pub async fn update_db_types(State(mut state): State<AppState>) {
    let mut stream = state
        .event_client
        .subscribe_to_stream("transport_type", &Default::default())
        .await;

    loop {
        let event = stream.next().await.unwrap();
        let ev = event
            .get_original_event()
            .as_json::<TransportTypeResponse>()
            .unwrap();
        let _: () = state.redis.json_del("trans_types", "$").await.unwrap();
        match event.event.unwrap().event_type.as_str() {
            "transport_type_add" => {
                let _ = sqlx::query!(
                    "insert into tb_transport_type (type_name) values ($1)", &ev.type_name)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();
            }
            "transport_type_update" => {
                let _ = sqlx::query!(
                    "update tb_transport_type set type_name = $1 where type_id = $2",
                    &ev.type_name,
                    &ev.type_id
                )
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let _: () = state
                    .redis
                    .json_del("trans_type".to_string() + &*ev.type_id.to_string(), "$")
                    .await
                    .unwrap();
            }
            "transport_type_delete" => {
                let _ = sqlx::query!(
                    "delete from tb_transport_type where type_id = $1",
                    &ev.type_id
                )
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let _: () = state
                    .redis
                    .json_del("trans_type".to_string() + &*ev.type_id.to_string(), "$")
                    .await
                    .unwrap();
            }
            _ => {}
        }
    }
}

pub async fn update_db_main(State(mut state): State<AppState>) {
    let mut stream = state
        .event_client
        .subscribe_to_stream("transport", &Default::default())
        .await;
    
    loop {
        let event = stream.next().await.unwrap();
        let ev = event.get_original_event().as_json::<Transport>().unwrap();
        let _: () = state.redis.json_del("trans", "$").await.map_err(MyError::RDbError).unwrap();
        match event.event.unwrap().event_type.as_str() {
            "transport_add" => {
                let _ = sqlx::query!("insert into tb_transport (transport_name, transport_reg_number, transport_type_id, transport_status_id) values ($1, $2, $3, $4)", &ev.transport_name, &ev.transport_reg_number, &ev.transport_type.type_id, &ev.transport_status.status_id)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();
            }
            "transport_update" => {
                let _ = sqlx::query!("update tb_transport set transport_name = $1, transport_reg_number = $2, transport_type_id = $3, transport_status_id = $4 where transport_id = $5", &ev.transport_name, &ev.transport_reg_number, &ev.transport_type.type_id, &ev.transport_status.status_id, &ev.transport_id)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let _: () = state
                    .redis
                    .json_del("user".to_string() + &*ev.transport_id.to_string(), "$")
                    .await
                    .unwrap();
            }
            "transport_delete" => {
                let _ = sqlx::query!(
                    "delete from tb_transport where transport_id = $1",
                    &ev.transport_id
                )
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let _: () = state
                    .redis
                    .json_del("user".to_string() + &*ev.transport_id.to_string(), "$")
                    .await
                    .unwrap();
            }
            _ => {}
        }
    }
}

pub async fn update_mongo(State(state): State<AppState>) {
    let mut stream = state
        .event_client
        .subscribe_to_stream("transport_geo", &Default::default())
        .await;
    
    loop {
        let event = stream.next().await.unwrap();
        let db = state.mongo.database("sdek");
        let coll: Collection<Document> = db.collection("transport_geo");
        let data = &event.get_original_event().data;
        let body: (TransportMongo, _) =
            bincode::decode_from_slice(data, bincode::config::standard()).unwrap();
        let doc = doc! {
            "$set": doc! {
                "lat": body.0.lat,
                "lon": body.0.lon
            },
        };
        let _ = coll
            .update_one(doc! {"transport_id": body.0.transport_id}, doc)
            .await
            .unwrap();
    }
}

pub async fn get_trans_pos(State(state): State<AppState>, ws: WebSocketUpgrade) -> Response {
    ws.on_upgrade(|socket| websocket_handler(socket, state))
}

async fn websocket_handler(mut socket: WebSocket, state: AppState) {
    loop {
        let msg = socket.recv().await.unwrap().unwrap();

        let transport_id: (String, _) = bincode::decode_from_slice(msg.into_data().as_slice(), bincode::config::standard()).unwrap();
        let id_bytes = transport_id.0.as_str();

        let db = state.mongo.database("sdek");
        let coll: Collection<Document> = db.collection("transport_geo");
        let filter = doc! { "transport_id": id_bytes };
        let res = coll.find_one(filter).await.unwrap().unwrap();

        let data = bincode::encode_to_vec(res.to_string(), bincode::config::standard()).unwrap();

        if socket.send(Message::Binary(data)).await.is_err() {
            return;
        }
    }
}
