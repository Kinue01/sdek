use std::any::Any;
use axum::extract::{Query, State};
use axum::Json;
use derive_more::Display;
use futures::StreamExt;
use itertools::Itertools;
use redis::{AsyncCommands, JsonAsyncCommands, RedisError, RedisResult};
use serde::Deserialize;
use sqlx::{Pool, Postgres, TransactionManager};
use uuid::Uuid;
use crate::{AppState};
use crate::error::MyError;
use crate::model::*;

async fn get_items(postgres: Pool<Postgres>, pack_items: Vec<PackageItems>) -> Vec<PackageItem> {
    let mut items: Vec<PackageItem> = Vec::new();
    for i in 0..pack_items.len()  {
        for j in 0..pack_items[i].item_quantity {
            items.push(sqlx::query_as!(PackageItem, "select * from tb_fitem where item_id = $1", pack_items[i].item_id)
                .fetch_one(&postgres)
                .await
                .map_err(MyError::DBError).unwrap());
        }
    }
    items
}

pub async fn get_packages(
    State(mut state): State<AppState>,
) -> Result<Json<Vec<Package>>, MyError> {
    // let packages_redis: Vec<Package> = state.redis.get("packages").await.unwrap();

    // match packages_redis.is_empty() {
    //     true => {
    //         
    //     }
    //     false => Ok(Json(packages_redis)),
    // }

    let packages = sqlx::query_as!(PackageResponse, "select * from tb_package")
        .fetch_all(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    let res = futures::stream::iter(packages)
        .map(|x| async {
            let postgres = state.postgres.clone();
            let yield_pg = state.postgres.clone();

            tokio::spawn(async move {
                let sender = sqlx::query_as!(ClientResponse, "select * from tb_fclient where client_id = $1", x.clone().package_sender_id)
                    .fetch_one(&postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let receiver = sqlx::query_as!(ClientResponse, "select * from tb_fclient where client_id = $1", x.clone().package_receiver_id)
                    .fetch_one(&postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let sender_user = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &sender.client_user_id)
                    .fetch_one(&postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let receiver_user = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &receiver.client_user_id)
                    .fetch_one(&postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let warehouse = sqlx::query_as!(WarehouseResponse, "select * from tb_fwarehouse where warehouse_id = $1", &x.package_warehouse_id)
                    .fetch_one(&postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let delivery: DeliveryPersonResponse;
                let delivery_user: UserResponse;
                let transport: TransportResponse;

                match x.package_deliveryperson_id {
                    Some(id) => {
                        delivery = sqlx::query_as!(DeliveryPersonResponse, "select * from tb_fdelivery_person where person_id = $1", id)
                            .fetch_one(&postgres)
                            .await
                            .map_err(MyError::DBError).unwrap();

                        delivery_user = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &delivery.person_user_id)
                            .fetch_one(&postgres)
                            .await
                            .map_err(MyError::DBError).unwrap();

                        transport = sqlx::query_as!(TransportResponse, "select * from tb_ftransport where transport_id = $1", &delivery.person_transport_id)
                            .fetch_one(&postgres)
                            .await
                            .map_err(MyError::DBError).unwrap();
                    }
                    None => {
                        delivery = DeliveryPersonResponse {
                            person_id: 0,
                            person_lastname: "".to_string(),
                            person_firstname: "".to_string(),
                            person_middlename: "".to_string(),
                            person_user_id: Default::default(),
                            person_transport_id: 0,
                        };

                        delivery_user = UserResponse {
                            user_id: Default::default(),
                            user_login: "".to_string(),
                            user_password: "".to_string(),
                            user_email: Option::from("".to_string()),
                            user_phone: "".to_string(),
                            user_access_token: Option::from("".to_string()),
                            user_role_id: 1,
                        };

                        transport = TransportResponse {
                            transport_id: 0,
                            transport_name: "".to_string(),
                            transport_reg_number: "".to_string(),
                            transport_type_id: 1,
                            transport_status_id: 1,
                        };
                    }
                }

                let items: Vec<PackageItems> = sqlx::query_as!(PackageItems, "select * from tb_fpackage_items where package_id = $1", &x.package_uuid)
                    .fetch_all(&postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();

                let mut payer: ClientResponse;
                let mut payer_user: UserResponse;

                if sender.client_id == x.package_payer_id {
                    payer = sender.clone();
                    payer_user = sender_user.clone();
                }
                else {
                    payer = receiver.clone();
                    payer_user = receiver_user.clone();
                }

                Package {
                    package_uuid: x.clone().package_uuid,
                    package_send_date: x.package_send_date.unwrap(),
                    package_receive_date: x.package_receive_date.unwrap(),
                    package_weight: x.package_weight.unwrap(),
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
                    package_sender: Client {
                        client_id: sender.client_id,
                        client_lastname: sender.client_lastname,
                        client_firstname: sender.client_firstname,
                        client_middlename: sender.client_middlename,
                        client_user: User {
                            user_id: sender_user.user_id,
                            user_login: sender_user.user_login,
                            user_password: sender_user.user_password,
                            user_email: sender_user.user_email.unwrap(),
                            user_phone: sender_user.user_phone,
                            user_access_token: sender_user.user_access_token.unwrap(),
                            user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &sender_user.user_role_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                        },
                    },
                    package_receiver: Client {
                        client_id: receiver.client_id,
                        client_lastname: receiver.client_lastname,
                        client_firstname: receiver.client_firstname,
                        client_middlename: receiver.client_middlename,
                        client_user: User {
                            user_id: receiver_user.user_id,
                            user_login: receiver_user.user_login,
                            user_password: receiver_user.user_password,
                            user_email: receiver_user.user_email.unwrap(),
                            user_phone: receiver_user.user_phone,
                            user_access_token: receiver_user.user_access_token.unwrap(),
                            user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &receiver_user.user_role_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                        },
                    },
                    package_warehouse: Warehouse {
                        warehouse_id: warehouse.warehouse_id,
                        warehouse_name: warehouse.warehouse_name,
                        warehouse_address: warehouse.warehouse_address,
                        warehouse_type: sqlx::query_as!(WarehouseTypeResponse, "select * from tb_fwarehouse_type where type_id = $1", warehouse.warehouse_type_id)
                            .fetch_one(&postgres)
                            .await
                            .map_err(MyError::DBError).unwrap(),
                    },
                    package_paytype: sqlx::query_as!(PackagePaytype, "select * from tb_package_paytype where type_id = $1", &x.package_paytype_id)
                        .fetch_one(&postgres)
                        .await
                        .map_err(MyError::DBError).unwrap(),
                    package_payer: Client {
                        client_id: payer.client_id,
                        client_lastname: payer.client_lastname,
                        client_firstname: payer.client_firstname,
                        client_middlename: payer.client_middlename,
                        client_user: User {
                            user_id: payer_user.user_id,
                            user_login: payer_user.user_login,
                            user_password: payer_user.user_password,
                            user_email: payer_user.user_email.unwrap(),
                            user_phone: payer_user.user_phone,
                            user_access_token: payer_user.user_access_token.unwrap(),
                            user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &payer_user.user_role_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                        },
                    },
                    package_items: get_items(yield_pg, items).await,
                    package_deliveryperson: Option::from(DeliveryPerson {
                        person_id: delivery.person_id,
                        person_lastname: delivery.person_lastname,
                        person_firstname: delivery.person_firstname,
                        person_middlename: delivery.person_middlename,
                        person_user: User {
                            user_id: delivery_user.user_id,
                            user_login: delivery_user.user_login,
                            user_password: delivery_user.user_password,
                            user_email: delivery_user.user_email.unwrap(),
                            user_phone: delivery_user.user_phone,
                            user_access_token: delivery_user.user_access_token.unwrap(),
                            user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &delivery_user.user_role_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                        },
                        person_transport: Transport {
                            transport_id: transport.transport_id,
                            transport_name: transport.transport_name,
                            transport_reg_number: transport.transport_reg_number,
                            transport_type: sqlx::query_as!(TransportTypeResponse, "select * from tb_ftransport_type where type_id = $1", transport.transport_type_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                            transport_status: sqlx::query_as!(TransportStatusResponse, "select * from tb_ftransport_status where status_id = $1", transport.transport_status_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                        },
                    })
                }
            })
                .await
                .unwrap()
        })
        .buffer_unordered(10)
        .collect::<Vec<_>>()
        .await;

    // let _: () = state.redis.set("packages", &res).await.unwrap();

    Ok(Json(res))
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

    match package_redis.package_uuid.to_string() == Uuid::default().to_string() {
        true => {
            let package = sqlx::query_as!(
                PackageResponse,
                "select * from tb_package where package_uuid = $1",
                uuid.0
            )
            .fetch_one(&state.postgres)
            .await
            .map_err(MyError::DBError)?;

            let sender = sqlx::query_as!(ClientResponse, "select * from tb_fclient where client_id = $1", package.package_sender_id)
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let receiver = sqlx::query_as!(ClientResponse, "select * from tb_fclient where client_id = $1", package.package_receiver_id)
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let sender_user = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &sender.client_user_id)
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let receiver_user = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &receiver.client_user_id)
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?;
            
            let warehouse = sqlx::query_as!(WarehouseResponse, "select * from tb_fwarehouse where warehouse_id = $1", &package.package_warehouse_id)
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let delivery: DeliveryPersonResponse;
            let delivery_user: UserResponse;
            let transport: TransportResponse;

            if package.package_deliveryperson_id.is_some() {
                delivery = sqlx::query_as!(DeliveryPersonResponse, "select * from tb_fdelivery_person where person_id = $1", &package.package_deliveryperson_id.unwrap())
                    .fetch_one(&state.postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                delivery_user = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &delivery.person_user_id)
                    .fetch_one(&state.postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                transport = sqlx::query_as!(TransportResponse, "select * from tb_ftransport where transport_id = $1", &delivery.person_transport_id)
                    .fetch_one(&state.postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();
            } else {
                delivery = DeliveryPersonResponse {
                    person_id: 0,
                    person_lastname: "".to_string(),
                    person_firstname: "".to_string(),
                    person_middlename: "".to_string(),
                    person_user_id: Default::default(),
                    person_transport_id: 0,
                };

                delivery_user = UserResponse {
                    user_id: Default::default(),
                    user_login: "".to_string(),
                    user_password: "".to_string(),
                    user_email: Option::from("".to_string()),
                    user_phone: "".to_string(),
                    user_access_token: Option::from("".to_string()),
                    user_role_id: 1,
                };

                transport = TransportResponse {
                    transport_id: 0,
                    transport_name: "".to_string(),
                    transport_reg_number: "".to_string(),
                    transport_type_id: 1,
                    transport_status_id: 1,
                };
            }

            let items = sqlx::query_as!(PackageItems, "select * from tb_fpackage_items where package_id = $1", &package.package_uuid)
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let mut payer: ClientResponse;
            let mut payer_user: UserResponse;

            if sender.client_id == package.package_payer_id {
                payer = sender.clone();
                payer_user = sender_user.clone();
            }
            else {
                payer = receiver.clone();
                payer_user = receiver_user.clone();
            }

            let res = Package {
                package_uuid: package.clone().package_uuid,
                package_send_date: package.package_send_date.unwrap(),
                package_receive_date: package.package_receive_date.unwrap(),
                package_weight: package.package_weight.unwrap(),
                package_deliveryperson: Option::from(DeliveryPerson {
                    person_id: delivery.person_id,
                    person_lastname: delivery.person_lastname,
                    person_firstname: delivery.person_firstname,
                    person_middlename: delivery.person_middlename,
                    person_user: User {
                        user_id: delivery_user.user_id,
                        user_login: delivery_user.user_login,
                        user_password: delivery_user.user_password,
                        user_email: delivery_user.user_email.unwrap(),
                        user_phone: delivery_user.user_phone,
                        user_access_token: delivery_user.user_access_token.unwrap(),
                        user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &delivery_user.user_role_id)
                            .fetch_one(&state.postgres)
                            .await
                            .map_err(MyError::DBError)?,
                    },
                    person_transport: Transport {
                        transport_id: transport.transport_id,
                        transport_name: transport.transport_name,
                        transport_reg_number: transport.transport_reg_number,
                        transport_type: sqlx::query_as!(TransportTypeResponse, "select * from tb_ftransport_type where type_id = $1", transport.transport_type_id)
                            .fetch_one(&state.postgres)
                            .await
                            .map_err(MyError::DBError)?,
                        transport_status: sqlx::query_as!(TransportStatusResponse, "select * from tb_ftransport_status where status_id = $1", transport.transport_status_id)
                            .fetch_one(&state.postgres)
                            .await
                            .map_err(MyError::DBError)?,
                    },
                }),
                package_type: sqlx::query_as!(
                    PackageType,
                    "select * from tb_package_type where type_id = $1",
                    &package.package_type_id
                )
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?,
                package_status: sqlx::query_as!(
                    PackageStatus,
                    "select * from tb_package_status where status_id = $1",
                    &package.package_status_id
                )
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?,
                package_sender: Client {
                    client_id: sender.client_id,
                    client_lastname: sender.client_lastname,
                    client_firstname: sender.client_firstname,
                    client_middlename: sender.client_middlename,
                    client_user: User {
                        user_id: sender_user.user_id,
                        user_login: sender_user.user_login,
                        user_password: sender_user.user_password,
                        user_email: sender_user.user_email.unwrap(),
                        user_phone: sender_user.user_phone,
                        user_access_token: sender_user.user_access_token.unwrap(),
                        user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &sender_user.user_role_id)
                            .fetch_one(&state.postgres)
                            .await
                            .map_err(MyError::DBError)?,
                    },
                },
                package_receiver: Client {
                    client_id: receiver.client_id,
                    client_lastname: receiver.client_lastname,
                    client_firstname: receiver.client_firstname,
                    client_middlename: receiver.client_middlename,
                    client_user: User {
                        user_id: receiver_user.user_id,
                        user_login: receiver_user.user_login,
                        user_password: receiver_user.user_password,
                        user_email: receiver_user.user_email.unwrap(),
                        user_phone: receiver_user.user_phone,
                        user_access_token: receiver_user.user_access_token.unwrap(),
                        user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &receiver_user.user_role_id)
                            .fetch_one(&state.postgres)
                            .await
                            .map_err(MyError::DBError)?,
                    },
                },
                package_warehouse: Warehouse {
                    warehouse_id: warehouse.warehouse_id,
                    warehouse_name: warehouse.warehouse_name,
                    warehouse_address: warehouse.warehouse_address,
                    warehouse_type: sqlx::query_as!(WarehouseTypeResponse, "select * from tb_fwarehouse_type where type_id = $1", warehouse.warehouse_type_id)
                        .fetch_one(&state.postgres)
                        .await
                        .map_err(MyError::DBError)?,
                },
                package_paytype: sqlx::query_as!(PackagePaytype, "select * from tb_package_paytype where type_id = $1", &package.package_paytype_id)
                    .fetch_one(&state.postgres)
                    .await
                    .map_err(MyError::DBError)?,
                package_payer: Client {
                    client_id: payer.client_id,
                    client_lastname: payer.client_lastname,
                    client_firstname: payer.client_firstname,
                    client_middlename: payer.client_middlename,
                    client_user: User {
                        user_id: payer_user.user_id,
                        user_login: payer_user.user_login,
                        user_password: payer_user.user_password,
                        user_email: payer_user.user_email.unwrap(),
                        user_phone: payer_user.user_phone,
                        user_access_token: payer_user.user_access_token.unwrap(),
                        user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &payer_user.user_role_id)
                            .fetch_one(&state.postgres)
                            .await
                            .map_err(MyError::DBError)?,
                    },
                },
                package_items: get_items(state.postgres, items).await,
            };
            
            let _: () = state.redis.set("package".to_owned() + &*uuid.0.to_string(), &res).await.unwrap();

            Ok(Json(res))
        }
        false => Ok(Json(package_redis)),
    }
}

#[derive(Deserialize, Display)]
pub struct IdShortParam {
    id: i16
}

pub async fn get_package_types(
    State(mut state): State<AppState>,
) -> Result<Json<Vec<PackageType>>, MyError> {
    let types = sqlx::query_as!(PackageType, "select * from tb_package_type")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;
            
            //let _: () = state.redis.set("packageTypes", &types).await.map_err(MyError::RDbError)?;

            Ok(Json(types))
}

pub async fn get_package_type_by_id(
    State(mut state): State<AppState>,
    id: Query<IdShortParam>,
) -> Result<Json<PackageType>, MyError> {
    let p_type = sqlx::query_as!(
        PackageType,
        "select * from tb_package_type where type_id = $1",
        &id.0.id
    )
    .fetch_one(&state.postgres)
    .await
    .map_err(MyError::DBError)?;

    // let _: () = state.redis.json_set("packageTypes", "$", &p_type).await.unwrap();

    Ok(Json(p_type))
}

pub async fn get_package_statuses(
    State(mut state): State<AppState>,
) -> Result<Json<Vec<PackageStatus>>, MyError> {
    let statuses = sqlx::query_as!(PackageStatus, "select * from tb_package_status")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;
            
            // let _: () = state.redis.set("packageStatuses", statuses.clone()).await.unwrap();

            Ok(Json(statuses))
}

pub async fn get_package_status_by_id(
    State(mut state): State<AppState>,
    id: Query<IdShortParam>,
) -> Result<Json<PackageStatus>, MyError> {
    let status = sqlx::query_as!(
        PackageStatus,
        "select * from tb_package_status where status_id = $1",
        &id.0.id
    )
    .fetch_one(&state.postgres)
    .await
    .map_err(MyError::DBError)?;
    
    // let _: () = state.redis.json_set("packageStatus".to_owned() + &*id.0.id.to_string(), "$", &status).await.unwrap();

    Ok(Json(status))
}

pub async fn get_packages_paytypes(State(state): State<AppState>) -> Result<Json<Vec<PackagePaytype>>, MyError> {
    let types = sqlx::query_as!(PackagePaytype, "select * from tb_package_paytype")
        .fetch_all(&state.postgres)
        .await
        .map_err(MyError::DBError)?;
    
    Ok(Json(types))
}

#[derive(Deserialize, Display)]
pub struct ClientPackagesParam {
    id: i32
}

pub async fn get_client_packages_by_id(
    State(mut state): State<AppState>,
    id: Query<ClientPackagesParam>,
) -> Result<Json<Vec<Package>>, MyError> {
    // let packages_client_redis: Vec<Package> = state
    //     .redis
    //     .json_get("packagesClient".to_owned() + id.0.id.to_string().as_str(), "$")
    //     .await
    //     .unwrap();

    // match packages_client_redis.is_empty() {
    //     true => {
    // 
    // 
    //         //let _: () = state.redis.json_set("packagesClient".to_owned() + id.0.id.to_string().as_str(), "$", &res).await.unwrap();
    // 
    // 
    //     }
    //     false => Ok(Json(packages_client_redis)),
    // }

    let packages = sqlx::query_as!(
                PackageResponse,
                "select * from tb_package where package_sender_id = $1",
                &id.0.id
            )
        .fetch_all(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    let res = futures::stream::iter(packages)
        .map(|x| async {
            let postgres = state.postgres.clone();

            tokio::spawn(async move {
                let sender = sqlx::query_as!(ClientResponse, "select * from tb_fclient where client_id = $1", x.clone().package_sender_id)
                    .fetch_one(&postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let receiver = sqlx::query_as!(ClientResponse, "select * from tb_fclient where client_id = $1", x.clone().package_receiver_id)
                    .fetch_one(&postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let sender_user = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &sender.client_user_id)
                    .fetch_one(&postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let receiver_user = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &receiver.client_user_id)
                    .fetch_one(&postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let warehouse = sqlx::query_as!(WarehouseResponse, "select * from tb_fwarehouse where warehouse_id = $1", &x.package_warehouse_id)
                    .fetch_one(&postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

                let delivery: DeliveryPersonResponse;
                let delivery_user: UserResponse;
                let transport: TransportResponse;

                if x.package_deliveryperson_id.is_some() {
                    delivery = sqlx::query_as!(DeliveryPersonResponse, "select * from tb_fdelivery_person where person_id = $1", &x.package_deliveryperson_id.unwrap())
                        .fetch_one(&postgres)
                        .await
                        .map_err(MyError::DBError).unwrap();

                    delivery_user = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &delivery.person_user_id)
                        .fetch_one(&postgres)
                        .await
                        .map_err(MyError::DBError).unwrap();

                    transport = sqlx::query_as!(TransportResponse, "select * from tb_ftransport where transport_id = $1", &delivery.person_transport_id)
                        .fetch_one(&postgres)
                        .await
                        .map_err(MyError::DBError).unwrap();
                } else {
                    delivery = DeliveryPersonResponse {
                        person_id: 0,
                        person_lastname: "".to_string(),
                        person_firstname: "".to_string(),
                        person_middlename: "".to_string(),
                        person_user_id: Default::default(),
                        person_transport_id: 0,
                    };

                    delivery_user = UserResponse {
                        user_id: Default::default(),
                        user_login: "".to_string(),
                        user_password: "".to_string(),
                        user_email: Option::from("".to_string()),
                        user_phone: "".to_string(),
                        user_access_token: Option::from("".to_string()),
                        user_role_id: 1,
                    };

                    transport = TransportResponse {
                        transport_id: 0,
                        transport_name: "".to_string(),
                        transport_reg_number: "".to_string(),
                        transport_type_id: 1,
                        transport_status_id: 1,
                    };
                }

                let items = sqlx::query_as!(PackageItems, "select * from tb_fpackage_items where package_id = $1", &x.package_uuid)
                    .fetch_all(&postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();

                let mut payer: ClientResponse;
                let mut payer_user: UserResponse;

                if sender.client_id == x.package_payer_id {
                    payer = sender.clone();
                    payer_user = sender_user.clone();
                }
                else {
                    payer = receiver.clone();
                    payer_user = receiver_user.clone();
                }

                Package {
                    package_uuid: x.clone().package_uuid,
                    package_send_date: x.package_send_date.unwrap(),
                    package_receive_date: x.package_receive_date.unwrap(),
                    package_weight: x.package_weight.unwrap(),
                    package_deliveryperson: Option::from(DeliveryPerson {
                        person_id: delivery.person_id,
                        person_lastname: delivery.person_lastname,
                        person_firstname: delivery.person_firstname,
                        person_middlename: delivery.person_middlename,
                        person_user: User {
                            user_id: delivery_user.user_id,
                            user_login: delivery_user.user_login,
                            user_password: delivery_user.user_password,
                            user_email: delivery_user.user_email.unwrap(),
                            user_phone: delivery_user.user_phone,
                            user_access_token: delivery_user.user_access_token.unwrap(),
                            user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &delivery_user.user_role_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                        },
                        person_transport: Transport {
                            transport_id: transport.transport_id,
                            transport_name: transport.transport_name,
                            transport_reg_number: transport.transport_reg_number,
                            transport_type: sqlx::query_as!(TransportTypeResponse, "select * from tb_ftransport_type where type_id = $1", &transport.transport_type_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                            transport_status: sqlx::query_as!(TransportStatusResponse, "select * from tb_ftransport_status where status_id = $1", &transport.transport_status_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                        },
                    }),
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
                    package_sender: Client {
                        client_id: sender.client_id,
                        client_lastname: sender.client_lastname,
                        client_firstname: sender.client_firstname,
                        client_middlename: sender.client_middlename,
                        client_user: User {
                            user_id: sender_user.user_id,
                            user_login: sender_user.user_login,
                            user_password: sender_user.user_password,
                            user_email: sender_user.user_email.unwrap(),
                            user_phone: sender_user.user_phone,
                            user_access_token: sender_user.user_access_token.unwrap(),
                            user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &sender_user.user_role_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                        },
                    },
                    package_receiver: Client {
                        client_id: receiver.client_id,
                        client_lastname: receiver.client_lastname,
                        client_firstname: receiver.client_firstname,
                        client_middlename: receiver.client_middlename,
                        client_user: User {
                            user_id: receiver_user.user_id,
                            user_login: receiver_user.user_login,
                            user_password: receiver_user.user_password,
                            user_email: receiver_user.user_email.unwrap(),
                            user_phone: receiver_user.user_phone,
                            user_access_token: receiver_user.user_access_token.unwrap(),
                            user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &receiver_user.user_role_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                        },
                    },
                    package_warehouse: Warehouse {
                        warehouse_id: warehouse.warehouse_id,
                        warehouse_name: warehouse.warehouse_name,
                        warehouse_address: warehouse.warehouse_address,
                        warehouse_type: sqlx::query_as!(WarehouseTypeResponse, "select * from tb_fwarehouse_type where type_id = $1", &warehouse.warehouse_type_id)
                            .fetch_one(&postgres)
                            .await
                            .map_err(MyError::DBError).unwrap(),
                    },
                    package_paytype: sqlx::query_as!(PackagePaytype, "select * from tb_package_paytype where type_id = $1", &x.package_paytype_id)
                        .fetch_one(&postgres)
                        .await
                        .map_err(MyError::DBError).unwrap(),
                    package_payer: Client {
                        client_id: payer.client_id,
                        client_lastname: payer.client_lastname,
                        client_firstname: payer.client_firstname,
                        client_middlename: payer.client_middlename,
                        client_user: User {
                            user_id: payer_user.user_id,
                            user_login: payer_user.user_login,
                            user_password: payer_user.user_password,
                            user_email: payer_user.user_email.unwrap(),
                            user_phone: payer_user.user_phone,
                            user_access_token: payer_user.user_access_token.unwrap(),
                            user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", &payer_user.user_role_id)
                                .fetch_one(&postgres)
                                .await
                                .map_err(MyError::DBError).unwrap(),
                        },
                    },
                    package_items: get_items(postgres, items).await,
                }
            })
                .await
                .unwrap()
        })
        .buffer_unordered(10)
        .collect::<Vec<_>>()
        .await;

    Ok(Json(res))
}

pub async fn update_db_types(State(mut state): State<AppState>) {
    let mut stream = state
        .event_client
        .subscribe_to_stream("package_type", &Default::default())
        .await;

    loop {
        let event = stream.next().await.unwrap();
        let ev = event.get_original_event().as_json::<PackageType>().unwrap();
        let _: () = state.redis.del("packageTypes").await.map_err(MyError::RDbError).unwrap();
        match event.event.unwrap().event_type.as_str() {
            "package_type_add" => {
                let _ = sqlx::query!("insert into tb_package_type (type_name, type_length, type_width, type_height) values ($1, $2, $3, $4)", &ev.type_name, &ev.type_length, &ev.type_width, &ev.type_height)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError).unwrap();
            }
            "package_type_update" => {
                let _ = sqlx::query!("update tb_package_type set type_name = $1, type_length = $2, type_width = $3, type_height = $4 where type_id = $5", &ev.type_name, &ev.type_length, &ev.type_width, &ev.type_height, &ev.type_id)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError).unwrap();

                let _: () = state
                    .redis
                    .del("packageType".to_owned() + &*ev.type_id.to_string())
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
                    .del("packageType".to_owned() + &*ev.type_id.to_string())
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
        .subscribe_to_stream("package_status", &Default::default())
        .await;

    loop {
        let event = stream.next().await.unwrap();
        let ev = event
            .get_original_event()
            .as_json::<PackageStatus>()
            .unwrap();
        let _: () = state.redis.del("packageStatuses").await.map_err(MyError::RDbError).unwrap();
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
                    .del("packageStatus".to_owned() + &*ev.status_id.to_string())
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
                    .del("packageStatus".to_owned() + &*ev.status_id.to_string())
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
        .subscribe_to_stream("package", &Default::default())
        .await;

    loop {
        let event = stream.next().await.unwrap();
        let ev = event.get_original_event().as_json::<Package>().unwrap();
        let _: () = state.redis.del("packages").await.map_err(MyError::RDbError).unwrap();
        let _: () = state.redis.del("packagesClient".to_owned() + ev.package_sender.client_id.to_string().as_str()).await.map_err(MyError::RDbError).unwrap();
        match event.event.unwrap().event_type.as_str() {
            "package_add" => {
                let _ = sqlx::query!("insert into tb_package (package_uuid, package_send_date, package_receive_date, package_weight, package_deliveryperson_id, package_type_id, package_status_id, package_sender_id, package_receiver_id, package_warehouse_id, package_paytype_id, package_payer_id) values (gen_random_uuid(), $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)", &ev.package_send_date, &ev.package_receive_date, &ev.package_weight, &ev.package_deliveryperson.unwrap().person_id, &ev.package_type.type_id, &ev.package_status.status_id, &ev.package_sender.client_id, &ev.package_receiver.client_id, &ev.package_warehouse.warehouse_id, &ev.package_paytype.type_id, &ev.package_payer.client_id)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();
                
                for x in ev.package_items.iter().unique() {
                    let _ = sqlx::query!("insert into tb_fitem (item_id, item_name, item_description, item_length, item_width, item_heigth, item_weight) values ((select max(item_id) from tb_fitem) + 1, $1, $2, $3, $4, $5, $6)", &x.item_name, &x.item_description, &x.item_length, &x.item_width, &x.item_heigth, &x.item_weight)
                        .execute(&state.postgres)
                        .await
                        .map_err(MyError::DBError).unwrap();
                }

                for x in ev.package_items.iter().unique() {
                    let package = sqlx::query!("select package_uuid from tb_package offset ((select count(*) from tb_package) - 1)")
                        .fetch_one(&state.postgres)
                        .await
                        .map_err(MyError::DBError).unwrap();
                    
                    let c = ev.package_items.iter().counts();
                    
                    let _ = sqlx::query!(
                        "insert into tb_fpackage_items values ($1, $2, $3)",
                        package.package_uuid,
                        &x.item_id,
                        c[x] as i32,
                    )
                        .execute(&state.postgres)
                        .await
                        .map_err(MyError::DBError).unwrap();
                }
            }
            "package_update" => {
                let _ = sqlx::query!("update tb_package set package_send_date = $1, package_receive_date = $2, package_weight = $3, package_deliveryperson_id = $4, package_type_id = $5, package_status_id = $6, package_sender_id = $7, package_receiver_id = $8, package_warehouse_id = $9, package_paytype_id = $10, package_payer_id = $11 where package_uuid = $12",  &ev.package_send_date, &ev.package_receive_date, &ev.package_weight, &ev.package_deliveryperson.unwrap().person_id, &ev.package_type.type_id, &ev.package_status.status_id, &ev.package_sender.client_id, &ev.package_receiver.client_id, &ev.package_warehouse.warehouse_id, &ev.package_paytype.type_id, &ev.package_payer.client_id, &ev.package_uuid)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError).unwrap();

                let _ = sqlx::query!("delete from tb_fpackage_items where package_id = $1", &ev.package_uuid)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();
                
                for x in ev.package_items.iter().unique() {
                    let _ = sqlx::query!("update tb_fitem set item_name = $1, item_description = $2, item_length = $3, item_width = $4, item_heigth = $5, item_weight = $6 where item_id = $7", &x.item_name, &x.item_description, &x.item_length, &x.item_width, &x.item_heigth, &x.item_weight, &x.item_id)
                        .execute(&state.postgres)
                        .await
                        .map_err(MyError::DBError).unwrap();
                }
                
                for x in ev.package_items.iter().unique() {
                    let c = ev.package_items.iter().counts();
                    
                    let _ = sqlx::query!(
                        "insert into tb_fpackage_items values ($1, $2, $3)",
                        &ev.package_uuid,
                        x.item_id,
                        c[x] as i32
                    )
                        .execute(&state.postgres)
                        .await
                        .map_err(MyError::DBError).unwrap();
                }
                
                let _: () = state.redis.del("package".to_owned() + &*ev.package_uuid.to_string()).await.map_err(MyError::RDbError).unwrap();
            }
            "package_delete" => {
                let _ = sqlx::query!(
                    "delete from tb_fpackage_items where package_id = $1",
                    &ev.package_uuid
                )
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();

                let _ = sqlx::query!("delete from tb_package where package_uuid = $1", &ev.package_uuid)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError).unwrap();

                let _: () = state.redis.del("package".to_owned() + &*ev.package_uuid.to_string()).await.map_err(MyError::RDbError).unwrap();
            }
            _ => {}
        }
    }
}
