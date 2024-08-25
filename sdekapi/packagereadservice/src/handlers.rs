use axum::extract::{Query, State};
use axum::Json;
use futures::StreamExt;
use redis::AsyncCommands;
use sqlx::{PgPool, Transaction, TransactionManager};
use sqlx::postgres::PgTransactionManager;
use uuid::Uuid;

use crate::AppState;
use crate::error::MyError;
use crate::model::*;

pub async fn get_packages(
    State(mut state): State<AppState>,
) -> Result<Json<Vec<Package>>, MyError> {
    let packages_redis: Vec<Package> = state.redis.get("packages").await.unwrap();

    match packages_redis.is_empty() {
        true => {
            let packages = sqlx::query_as!(PackageResponse, "select * from tb_package")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let res = futures::stream::iter(packages)
                .map(|x| async {
                    let postgres = state.postgres.clone();
                    let http = state.http_client.clone();

                    tokio::spawn(async move {
                        Package {
                            package_uuid: x.clone().package_uuid,
                            package_transport: serde_json::from_str(
                                http.get(format!(
                                    "http://localhost:8015/transport?id={}",
                                    &x.package_transport_id
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
                            package_type: sqlx::query_as!(
                                PackageType,
                                "select * from tb_package_type where type_id = $1",
                                &x.package_type_id
                            )
                            .fetch_one(&postgres)
                            .await
                            .map_err(MyError::DBError)
                            .unwrap(),
                            package_status: sqlx::query_as!(
                                PackageStatus,
                                "select * from tb_package_status where status_id = $1",
                                &x.package_status_id
                            )
                            .fetch_one(&postgres)
                            .await
                            .map_err(MyError::DBError)
                            .unwrap(),
                            package_sender: serde_json::from_str(
                                http.get(format!(
                                    "http://localhost:8011/client?id={}",
                                    &x.package_sender_id
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
                            package_items: sqlx::query_as!(
                                PackageItem,
                                "select * from tb_package_items where package_id = $1",
                                &x.package_uuid
                            )
                            .fetch_all(&postgres)
                            .await
                            .map_err(MyError::DBError)
                            .unwrap(),
                        }
                    })
                    .await
                    .unwrap_or_default()
                })
                .buffer_unordered(10)
                .collect::<Vec<_>>()
                .await;

            let _: () = state.redis.set("packages", &res).await.unwrap();

            Ok(Json(res))
        }
        false => Ok(Json(packages_redis)),
    }
}

pub async fn get_package_by_id(
    State(mut state): State<AppState>,
    uuid: Query<Uuid>,
) -> Result<Json<Package>, MyError> {
    let package_redis: Package = state
        .redis
        .get("package".to_owned() + &*uuid.0.to_string())
        .await
        .unwrap();

    match package_redis.package_uuid == Default::default() {
        true => {
            let package = sqlx::query_as!(
                PackageResponse,
                "select * from tb_package where package_uuid = $1",
                uuid.0
            )
            .fetch_one(&state.postgres)
            .await
            .map_err(MyError::DBError)?;

            let res = Package {
                package_uuid: package.clone().package_uuid,
                package_transport: serde_json::from_str(
                    state
                        .http_client
                        .get(format!(
                            "http://localhost:8015/transport?id={}",
                            &package.package_transport_id
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
                package_type: sqlx::query_as!(
                    PackageType,
                    "select * from tb_package_type where type_id = $1",
                    &package.package_type_id
                )
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)
                .unwrap(),
                package_status: sqlx::query_as!(
                    PackageStatus,
                    "select * from tb_package_status where status_id = $1",
                    &package.package_status_id
                )
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)
                .unwrap(),
                package_sender: serde_json::from_str(
                    state
                        .http_client
                        .get(format!(
                            "http://localhost:8011/client?id={}",
                            &package.package_sender_id
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
                package_items: sqlx::query_as!(
                    PackageItem,
                    "select * from tb_package_items where package_id = $1",
                    &package.package_uuid
                )
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)
                .unwrap(),
            };

            Ok(Json(res))
        }
        false => Ok(Json(package_redis)),
    }
}

pub async fn get_package_types(
    State(mut state): State<AppState>,
) -> Result<Json<Vec<PackageType>>, MyError> {
    let types_redis: Vec<PackageType> = state.redis.get("package_types").await.unwrap();

    match types_redis.is_empty() {
        true => {
            let types = sqlx::query_as!(PackageType, "select * from tb_package_type")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let _: () = state.redis.set("package_types", &types).await.unwrap();

            Ok(Json(types))
        }
        false => Ok(Json(types_redis)),
    }
}

pub async fn get_package_type_by_id(
    State(mut state): State<AppState>,
    id: Query<i16>,
) -> Result<Json<PackageType>, MyError> {
    let type_redis: PackageType = state
        .redis
        .get("package_type".to_owned() + &*id.0.to_string())
        .await
        .unwrap();

    match type_redis.type_id == 0 {
        true => {
            let p_type = sqlx::query_as!(
                PackageType,
                "select * from tb_package_type where type_id = $1",
                &id.0
            )
            .fetch_one(&state.postgres)
            .await
            .map_err(MyError::DBError)?;

            let _: () = state.redis.set("package_types", &p_type).await.unwrap();

            Ok(Json(p_type))
        }
        false => Ok(Json(type_redis)),
    }
}

pub async fn get_package_statuses(
    State(mut state): State<AppState>,
) -> Result<Json<Vec<PackageStatus>>, MyError> {
    let statuses_redis: Vec<PackageStatus> = state.redis.get("package_statuses").await.unwrap();

    match statuses_redis.is_empty() {
        true => {
            let statuses = sqlx::query_as!(PackageStatus, "select * from tb_package_status")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            Ok(Json(statuses))
        }
        false => Ok(Json(statuses_redis)),
    }
}

pub async fn get_package_status_by_id(
    State(mut state): State<AppState>,
    id: Query<i16>,
) -> Result<Json<PackageStatus>, MyError> {
    let status_redis: PackageStatus = state
        .redis
        .get("package_status".to_owned() + &*id.0.to_string())
        .await
        .unwrap();

    match status_redis.status_id == 0 {
        true => {
            let status = sqlx::query_as!(
                PackageStatus,
                "select * from tb_package_status where status_id = $1",
                &id.0
            )
            .fetch_one(&state.postgres)
            .await
            .map_err(MyError::DBError)?;

            Ok(Json(status))
        }
        false => Ok(Json(status_redis)),
    }
}

pub async fn get_client_packages_by_id(
    State(mut state): State<AppState>,
    id: Query<i32>,
) -> Result<Json<Vec<Package>>, MyError> {
    let packages_client_redis: Vec<Package> = state
        .redis
        .get("packages_client".to_owned() + id.0.to_string().as_str())
        .await
        .unwrap();

    match packages_client_redis.is_empty() {
        true => {
            let packages = sqlx::query_as!(
                PackageResponse,
                "select * from tb_package where package_sender_id = $1",
                &id.0
            )
            .fetch_all(&state.postgres)
            .await
            .map_err(MyError::DBError)?;

            let res = futures::stream::iter(packages)
                .map(|x| async {
                    let postgres = state.postgres.clone();
                    let http = state.http_client.clone();

                    tokio::spawn(async move {
                        Package {
                            package_uuid: x.clone().package_uuid,
                            package_transport: serde_json::from_str(
                                http.get(format!(
                                    "http://localhost:8015/transport?id={}",
                                    &x.package_transport_id
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
                            package_type: sqlx::query_as!(
                                PackageType,
                                "select * from tb_package_type where type_id = $1",
                                &x.package_type_id
                            )
                            .fetch_one(&postgres)
                            .await
                            .map_err(MyError::DBError)
                            .unwrap(),
                            package_status: sqlx::query_as!(
                                PackageStatus,
                                "select * from tb_package_status where status_id = $1",
                                &x.package_status_id
                            )
                            .fetch_one(&postgres)
                            .await
                            .map_err(MyError::DBError)
                            .unwrap(),
                            package_sender: serde_json::from_str(
                                http.get(format!(
                                    "http://localhost:8011/client?id={}",
                                    &x.package_sender_id
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
                            package_items: sqlx::query_as!(
                                PackageItem,
                                "select * from tb_package_items where package_id = $1",
                                &x.package_uuid
                            )
                            .fetch_all(&postgres)
                            .await
                            .map_err(MyError::DBError)
                            .unwrap(),
                        }
                    })
                    .await
                    .unwrap_or_default()
                })
                .buffer_unordered(10)
                .collect::<Vec<_>>()
                .await;

            let _: () = state.redis.set("packages", &res).await.unwrap();

            Ok(Json(res))
        }
        false => Ok(Json(packages_client_redis)),
    }
}

pub async fn update_db_types(State(mut state): State<AppState>) {
    let mut stream = state
        .event_client
        .read_stream("package_type", &Default::default())
        .await
        .unwrap();

    while let Some(event) = stream.next().await.unwrap() {
        let ev = event.get_original_event().as_json::<PackageType>().unwrap();
        match event.event.unwrap().event_type.as_str() {
            "package_type_add" => {
                let _ = sqlx::query!("insert into tb_package_type (type_name, type_length, type_width, type_height, type_weight) values ($1, $2, $3, $4, $5)", &ev.type_name, &ev.type_length, &ev.type_width, &ev.type_height, &ev.type_weight)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError).unwrap();
            }
            "package_type_update" => {
                let _ = sqlx::query!("update tb_package_type set type_name = $1, type_length = $2, type_width = $3, type_height = $4, type_weight = $5 where type_id = $6", &ev.type_name, &ev.type_length, &ev.type_width, &ev.type_height, &ev.type_weight, &ev.type_id)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError).unwrap();

                let _: () = state
                    .redis
                    .del("package_type".to_owned() + &*ev.type_id.to_string())
                    .await
                    .unwrap();
            }
            "package_type_delete" => {
                let _ = sqlx::query!(
                    "delete from tb_package_type where type_id = $1",
                    &ev.type_id
                )
                .execute(&state.postgres)
                .await
                .map_err(MyError::DBError)
                .unwrap();

                let _: () = state
                    .redis
                    .del("package_type".to_owned() + &*ev.type_id.to_string())
                    .await
                    .unwrap();
            }
            _ => {}
        }
    }
}

pub async fn update_db_statuses(State(mut state): State<AppState>) {
    let mut stream = state
        .event_client
        .read_stream("package_status", &Default::default())
        .await
        .unwrap();

    while let Some(event) = stream.next().await.unwrap() {
        let ev = event
            .get_original_event()
            .as_json::<PackageStatus>()
            .unwrap();
        match event.event.unwrap().event_type.as_str() {
            "package_status_add" => {
                let _ = sqlx::query!(
                    "insert into tb_package_status (status_name) values ($1)",
                    &ev.status_name
                )
                .execute(&state.postgres)
                .await
                .map_err(MyError::DBError)
                .unwrap();
            }
            "package_status_update" => {
                let _ = sqlx::query!(
                    "update tb_package_status set status_name = $1 where status_id = $2",
                    &ev.status_name,
                    &ev.status_id
                )
                .execute(&state.postgres)
                .await
                .map_err(MyError::DBError)
                .unwrap();

                let _: () = state
                    .redis
                    .del("package_status".to_owned() + &*ev.status_id.to_string())
                    .await
                    .unwrap();
            }
            "package_status_delete" => {
                let _ = sqlx::query!(
                    "delete from tb_package_status where status_id = $1",
                    &ev.status_id
                )
                .execute(&state.postgres)
                .await
                .map_err(MyError::DBError)
                .unwrap();

                let _: () = state
                    .redis
                    .del("package_status".to_owned() + &*ev.status_id.to_string())
                    .await
                    .unwrap();
            }
            _ => {}
        }
    }
}

pub async fn update_db_main(State(state): State<AppState>) {
    let mut stream = state
        .event_client
        .read_stream("package", &Default::default())
        .await
        .unwrap();

    while let Some(event) = stream.next().await.unwrap() {
        let ev = event.get_original_event().as_json::<Package>().unwrap();
        match event.event.unwrap().event_type.as_str() {
            "package_add" => {
                let _ = sqlx::query!("insert into tb_package (package_transport_id, package_type_id, package_status_id, package_sender_id) values ($1, $2, $3, $4)", &ev.package_transport.transport_id, &ev.package_type.type_id, &ev.package_status.status_id, &ev.package_sender.client_id)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError).unwrap();

                for x in ev.package_items {
                    let _ = sqlx::query!(
                        "insert into tb_package_items values ($1, $2, $3, $4, $5, $6)",
                        x.package_id,
                        x.item_name,
                        x.item_length,
                        x.item_width,
                        x.item_heigth,
                        x.item_weight
                    )
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError);
                }
            }
            "package_update" => {
                let _ = sqlx::query!("update tb_package set package_transport_id = $1, package_type_id = $2, package_status_id = $3, package_sender_id = $4 where package_uuid = $5", &ev.package_transport.transport_id, &ev.package_type.type_id, &ev.package_status.status_id, &ev.package_sender.client_id, &ev.package_uuid)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError).unwrap();

                let _ = sqlx::query!(
                    "delete from tb_package_items where package_id = $1",
                    &ev.package_uuid
                )
                .execute(&state.postgres)
                .await
                .map_err(MyError::DBError)
                .unwrap();

                for x in ev.package_items {
                    let _ = sqlx::query!(
                        "insert into tb_package_items values ($1, $2, $3, $4, $5, $6)",
                        x.package_id,
                        x.item_name,
                        x.item_length,
                        x.item_width,
                        x.item_heigth,
                        x.item_weight
                    )
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError);
                }
            }
            "package_delete" => {
                let _ = sqlx::query!(
                    "delete from tb_package_items where package_id = $1",
                    &ev.package_uuid
                )
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();
                
                let _ = sqlx::query!("delete from tb_package where package_uuid = $1", &ev.package_uuid)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError).unwrap();
            }
            _ => {}
        }
    }
}
