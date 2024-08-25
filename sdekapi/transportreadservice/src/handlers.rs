use axum::extract::{Query, State};
use axum::Json;
use futures::StreamExt;
use mongodb::bson::{doc, Document};
use mongodb::Collection;
use redis::AsyncCommands;
use uuid::Uuid;

use crate::AppState;
use crate::error::MyError;
use crate::model::*;

pub async fn get_transport_types(
    State(mut state): State<AppState>,
) -> Result<Json<Vec<TransportTypeResponse>>, MyError> {
    let types_redis: Vec<TransportTypeResponse> =
        state.redis.get("trans_types").await.unwrap_or_default();

    match types_redis.is_empty() {
        true => {
            let res = sqlx::query_as!(TransportTypeResponse, "select * from tb_transport_type")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let _: () = state.redis.set("trans_types", &res).await.unwrap();

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
        .get("trans_type".to_string() + &*id.0.to_string())
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
                .set("trans_type".to_string() + &*id.0.to_string(), &res)
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
    let trans_redis: Vec<Transport> = state.redis.get("trans").await.unwrap_or_default();

    match trans_redis.is_empty() {
        true => {
            let trans = sqlx::query_as!(TransportResponse, "select * from tb_transport")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let stream = futures::stream::iter(trans)
                .map(|x| async {
                    let postgres = state.postgres.clone();
                    let http = state.http_client.clone();

                    tokio::spawn(async move {
                        Transport {
                            transport_id: x.transport_id,
                            transport_name: x.clone().transport_name,
                            transport_type: sqlx::query_as!(
                                TransportTypeResponse,
                                "select * from tb_transport_type where type_id = $1",
                                x.transport_type_id
                            )
                            .fetch_one(&postgres)
                            .await
                            .unwrap_or_default(),
                            transport_driver: serde_json::from_str(
                                http.get(format!(
                                    "http://localhost:8012/employee?uuid={}",
                                    &x.transport_driver_id
                                ))
                                .send()
                                .await
                                .unwrap()
                                .text()
                                .await
                                .unwrap()
                                .as_str(),
                            )
                            .unwrap(),
                        }
                    })
                    .await
                    .unwrap_or_default()
                })
                .buffer_unordered(10)
                .collect::<Vec<_>>()
                .await;

            let _: () = state.redis.set("trans", &stream).await.unwrap_or_default();

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
        .get("trans".to_owned() + &*id.0.to_string())
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
                transport_type: sqlx::query_as!(
                    TransportTypeResponse,
                    "select * from tb_transport_type where type_id = $1",
                    trans.transport_type_id
                )
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?,
                transport_driver: serde_json::from_str(
                    state
                        .http_client
                        .get(format!(
                            "http://localhost:8012/employee?uuid={}",
                            trans.transport_driver_id
                        ))
                        .send()
                        .await
                        .unwrap()
                        .text()
                        .await
                        .unwrap()
                        .as_str(),
                )
                .unwrap(),
            };

            let _: () = state
                .redis
                .set("trans".to_owned() + &*id.0.to_string(), &res)
                .await
                .unwrap();

            Ok(Json(res))
        }
        false => Ok(Json(trans_redis)),
    }
}

pub async fn get_transport_by_driver_id(
    State(state): State<AppState>,
    uuid: Query<Uuid>,
) -> Result<Json<Transport>, MyError> {
    let trans = sqlx::query_as!(
        TransportResponse,
        "select * from tb_transport where transport_driver_id = $1",
        uuid.0
    )
    .fetch_one(&state.postgres)
    .await
    .map_err(MyError::DBError)?;

    let res = get_transport_by_id(State(state), Query(trans.transport_id))
        .await
        .unwrap_or_default()
        .0;

    Ok(Json(res))
}

pub async fn update_db_types(State(mut state): State<AppState>) {
    let mut stream = state
        .event_client
        .read_stream("transport_type", &Default::default())
        .await
        .unwrap();

    while let Some(event) = stream.next().await.unwrap() {
        let ev = event
            .get_original_event()
            .as_json::<TransportTypeResponse>()
            .unwrap();
        match event.event.unwrap().event_type.as_str() {
            "transport_type_add" => {
                let _ = sqlx::query!(
                    "insert into tb_transport_type (type_id, type_name) values (1, 2)"
                )
                .bind(&ev.type_id)
                .bind(&ev.type_name)
                .execute(&state.postgres)
                .await
                .map_err(MyError::DBError);
            }
            "transport_type_update" => {
                let _ = sqlx::query!(
                    "update tb_transport_type set type_name = $1 where type_id = $2",
                    &ev.type_name,
                    &ev.type_id
                )
                .execute(&state.postgres)
                .await
                .map_err(MyError::DBError);

                let t = sqlx::query_as!(
                    TransportTypeResponse,
                    "select * from tb_transport_type where type_id = $1",
                    ev.type_id
                )
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)
                .unwrap();

                let _: () = state
                    .redis
                    .set("trans_type".to_string() + &*ev.type_id.to_string(), t)
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
                .map_err(MyError::DBError);

                let _: () = state
                    .redis
                    .del("trans_type".to_string() + &*ev.type_id.to_string())
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
        .read_stream("transport", &Default::default())
        .await
        .unwrap();

    while let Some(event) = stream.next().await.unwrap() {
        let ev = event.get_original_event().as_json::<Transport>().unwrap();
        match event.event.unwrap().event_type.as_str() {
            "transport_add" => {
                let _ = sqlx::query!("insert into tb_transport (transport_name, transport_type_id, transport_driver_id) values ($1, $2, $3)", &ev.transport_name, &ev.transport_type.type_id, &ev.transport_driver.employee_id)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError);
            }
            "transport_update" => {
                let _ = sqlx::query!("update tb_transport set transport_name = $1, transport_type_id = $2, transport_driver_id = $3 where transport_id = $4", &ev.transport_name, &ev.transport_type.type_id, &ev.transport_driver.employee_id, &ev.transport_id)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError);

                let _: () = state
                    .redis
                    .del("user".to_string() + &*ev.transport_id.to_string())
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
                .map_err(MyError::DBError);

                let _: () = state
                    .redis
                    .del("user".to_string() + &*ev.transport_id.to_string())
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
        .read_stream("transport_geo", &Default::default())
        .await
        .unwrap();

    while let Some(event) = stream.next().await.unwrap() {
        let db = state.mongo.database("transport");
        let coll: Collection<Document> = db.collection("transport_geo");
        let data = event.event.unwrap().data;
        let body: (TransportMongo, _) =
            bincode::decode_from_slice(data.as_ref(), bincode::config::standard()).unwrap();
        let doc = doc! {
            "$set": doc! {
                "lat": body.0.lat,
                "lon": body.0.lon
            },
        };
        let _ = coll
            .update_one(doc! {"driver_id": body.0.driver_id}, doc)
            .await
            .unwrap();
    }
}
