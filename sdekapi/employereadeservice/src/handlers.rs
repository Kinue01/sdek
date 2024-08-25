use axum::extract::{Query, State};
use axum::Json;
use futures::StreamExt;
use redis::AsyncCommands;
use serde::Deserialize;
use utoipa::IntoParams;
use uuid::Uuid;

use crate::AppState;
use crate::error::MyError;
use crate::model::*;

#[utoipa::path(
    get,
    path = "/api/employees",
    responses(
        (status = 200, description = "Success", body = Vec < Employee >),
        (status = 404, description = "Employees not found")
    )
)]
pub async fn get_employees(
    State(mut state): State<AppState>,
) -> Result<Json<Vec<Employee>>, MyError> {
    let emps_redis: Vec<Employee> = state.redis.get("emps").await.unwrap_or_default();

    match emps_redis.is_empty() {
        true => {
            let emps = sqlx::query_as!(EmployeeResponse, "select * from tb_employee")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let res = futures::stream::iter(emps)
                .map(|x| async {
                    let postgres = state.postgres.clone();
                    let http = state.http_client.clone();

                    tokio::spawn(async move {
                        let user: User = serde_json::from_str(
                            http.get(format!(
                                "http://localhost:8010/api/user?uuid={}",
                                x.clone().employee_user_id
                            ))
                            .send()
                            .await
                            .unwrap()
                            .text()
                            .await
                            .unwrap()
                            .as_str(),
                        )
                        .unwrap();

                        Employee {
                            employee_id: x.employee_id,
                            employee_lastname: x.employee_lastname,
                            employee_firstname: x.employee_firstname,
                            employee_middlename: x.employee_middlename,
                            employee_position: sqlx::query_as!(
                                PositionResponse,
                                "select * from tb_position where position_id = $1",
                                &x.employee_position_id
                            )
                            .fetch_one(&postgres)
                            .await
                            .map_err(MyError::DBError)
                            .unwrap(),
                            employee_user: User {
                                user_id: user.user_id,
                                user_login: user.user_login,
                                user_password: user.user_password,
                                user_email: user.user_email,
                                user_phone: user.user_phone,
                                user_access_token: user.user_access_token,
                                user_role: serde_json::from_str(
                                    http.get(format!(
                                        "http://localhost:8010/api/role?id={}",
                                        &user.user_role.role_id
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
                            },
                        }
                    })
                    .await
                    .unwrap_or_default()
                })
                .buffer_unordered(10)
                .collect::<Vec<_>>()
                .await;

            let _: () = state.redis.set("emps", &res).await.unwrap();

            Ok(Json(res))
        }
        false => Ok(Json(emps_redis)),
    }
}

#[derive(Deserialize, IntoParams)]
struct EmpSearchQuery {
    uuid: Uuid,
}

#[utoipa::path(
    get,
    path = "/api/employee",
    responses(
        (status = 200, description = "Ok", body = Employee),
        (status = 404, description = "Employee not found")
    ),
    params(
        EmpSearchQuery
    )
)]
pub async fn get_employee_by_id(
    State(mut state): State<AppState>,
    uuid: Query<Uuid>,
) -> Result<Json<Employee>, MyError> {
    let emp_redis: Employee = state
        .redis
        .get("emp".to_owned() + &*uuid.0.to_string())
        .await
        .unwrap_or_default();

    match emp_redis.employee_id {
        u if u == Uuid::default() => {
            let emp = sqlx::query_as!(
                EmployeeResponse,
                "select * from tb_employee where employee_id = $1",
                &uuid.0
            )
            .fetch_one(&state.postgres)
            .await
            .map_err(MyError::DBError)?;

            let user: User = serde_json::from_str(
                state
                    .http_client
                    .get(format!(
                        "http://localhost:8010/api/user?uuid={}",
                        emp.employee_user_id
                    ))
                    .send()
                    .await
                    .unwrap()
                    .text()
                    .await
                    .unwrap()
                    .as_str(),
            )
            .unwrap();

            let res = Employee {
                employee_id: emp.employee_id,
                employee_lastname: emp.employee_lastname,
                employee_firstname: emp.employee_firstname,
                employee_middlename: emp.employee_middlename,
                employee_position: sqlx::query_as!(
                    PositionResponse,
                    "select * from tb_position where position_id = $1",
                    &emp.employee_position_id
                )
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?,
                employee_user: user,
            };

            let _: () = state
                .redis
                .set("emp".to_owned() + &*uuid.0.to_string(), &res)
                .await
                .unwrap();

            Ok(Json(res))
        }
        _ => Ok(Json(emp_redis)),
    }
}

pub async fn get_employee_by_user_id(
    State(mut state): State<AppState>,
    uuid: Query<Uuid>,
) -> Result<Json<Employee>, MyError> {
    let emp = sqlx::query_as!(
        EmployeeResponse,
        "select * from tb_employee where employee_user_id = $1",
        uuid.0
    )
    .fetch_one(&state.postgres)
    .await
    .map_err(MyError::DBError)?;

    let emp_redis: Employee = state
        .redis
        .get("emp".to_owned() + &*emp.employee_id.to_string())
        .await
        .unwrap_or_default();

    match emp_redis.employee_id {
        u if u == Uuid::default() => {
            let user: User = serde_json::from_str(
                state
                    .http_client
                    .get(format!(
                        "http://localhost:8010/api/user?uuid={}",
                        emp.employee_user_id
                    ))
                    .send()
                    .await
                    .unwrap()
                    .text()
                    .await
                    .unwrap()
                    .as_str(),
            )
            .unwrap();

            let res = Employee {
                employee_id: emp.employee_id,
                employee_lastname: emp.employee_lastname,
                employee_firstname: emp.employee_firstname,
                employee_middlename: emp.employee_middlename,
                employee_position: sqlx::query_as!(
                    PositionResponse,
                    "select * from tb_position where position_id = $1",
                    &emp.employee_position_id
                )
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?,
                employee_user: user,
            };

            let _: () = state
                .redis
                .set("emp".to_owned() + &*uuid.0.to_string(), &res)
                .await
                .unwrap();

            Ok(Json(res))
        }
        _ => Ok(Json(emp_redis)),
    }
}

#[utoipa::path(
    get,
    path = "/api/positions",
    responses(
        (status = 200, description = "Success", body = Vec < PositionResponse >),
        (status = 404, description = "Positions not found")
    )
)]
pub async fn get_positions(
    State(mut state): State<AppState>,
) -> Result<Json<Vec<PositionResponse>>, MyError> {
    let poses_redis: Vec<PositionResponse> =
        state.redis.get("poses").await.map_err(MyError::RDbError)?;

    match poses_redis.is_empty() {
        true => {
            let poses = sqlx::query_as!(PositionResponse, "select * from tb_position")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let _: () = state.redis.set("poses", &poses).await.unwrap();

            Ok(Json(poses))
        }
        false => Ok(Json(poses_redis)),
    }
}

#[derive(Deserialize, IntoParams)]
struct PosSearchQuery {
    id: i16,
}

#[utoipa::path(
    get,
    path = "/api/position",
    responses(
        (status = 200, description = "Success", body = Vec < PositionResponse >),
        (status = 404, description = "Positions not found")
    ),
    params(
        PosSearchQuery
    )
)]
pub async fn get_position_by_id(
    State(mut state): State<AppState>,
    id: Query<i16>,
) -> Result<Json<PositionResponse>, MyError> {
    let pos_redis: PositionResponse = state
        .redis
        .get("pos".to_string() + &*id.0.to_string())
        .await
        .map_err(MyError::RDbError)?;

    match pos_redis.position_id == 0 {
        true => {
            let pos = sqlx::query_as!(
                PositionResponse,
                "select * from tb_position where position_id = $1",
                id.0
            )
            .fetch_one(&state.postgres)
            .await
            .map_err(MyError::DBError)?;

            let _: () = state
                .redis
                .set("pos".to_string() + &*id.0.to_string(), &pos)
                .await
                .unwrap();

            Ok(Json(pos))
        }
        false => Ok(Json(pos_redis)),
    }
}

pub async fn update_db_poses(State(mut state): State<AppState>) {
    let mut stream = state
        .event_client
        .read_stream("position", &Default::default())
        .await
        .unwrap();

    while let Some(event) = stream.next().await.unwrap() {
        let ev = event
            .get_original_event()
            .as_json::<PositionResponse>()
            .unwrap();
        match event.event.unwrap().event_type.as_str() {
            "position_add" => {
                let _ = sqlx::query!(
                    "insert into tb_position (position_name, position_base_pay) values ($1, $2)",
                    &ev.position_name,
                    &ev.position_base_pay
                )
                .execute(&state.postgres)
                .await
                .map_err(MyError::DBError);
            }
            "position_update" => {
                let _ = sqlx::query!("update tb_position set position_name = $1, position_base_pay = $2 where position_id = $3", &ev.position_name, &ev.position_base_pay, &ev.position_id)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError);

                let pos = get_position_by_id(State(state.clone()), Query(ev.position_id))
                    .await
                    .unwrap_or_default()
                    .0;

                let _: () = state
                    .redis
                    .set("pos".to_string() + &*ev.position_id.to_string(), pos)
                    .await
                    .unwrap();
            }
            "position_delete" => {
                let _ = sqlx::query!(
                    "insert into tb_position (position_name, position_base_pay) values ($1, $2)",
                    &ev.position_name,
                    &ev.position_base_pay
                )
                .execute(&state.postgres)
                .await
                .map_err(MyError::DBError);

                let _: () = state
                    .redis
                    .del("pos".to_string() + &*ev.position_id.to_string())
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
        .read_stream("employee", &Default::default())
        .await
        .unwrap();

    while let Some(event) = stream.next().await.unwrap() {
        let ev = event.get_original_event().as_json::<Employee>().unwrap();
        match event.event.unwrap().event_type.as_str() {
            "employee_add" => {
                let _ = sqlx::query!("insert into tb_employee (employee_lastname, employee_firstname, employee_middlename, employee_position_id, employee_user_id) values ($1, $2, $3, $4, $5)", &ev.employee_lastname, &ev.employee_firstname, &ev.employee_middlename, &ev.employee_position.position_id, &ev.employee_user.user_id)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError);
            }
            "employee_update" => {
                let _ = sqlx::query!("update tb_employee set employee_lastname = $1, employee_firstname = $2, employee_middlename = $3, employee_position_id = $4, employee_user_id = $5 where employee_id = $6", &ev.employee_lastname, &ev.employee_firstname, &ev.employee_middlename, &ev.employee_position.position_id, &ev.employee_user.user_id, &ev.employee_id)
                    .execute(&state.postgres)
                    .await.map_err(MyError::DBError);

                let _: () = state
                    .redis
                    .del("emp".to_owned() + &*ev.employee_id.to_string())
                    .await
                    .unwrap();
            }
            "employee_delete" => {
                let _ = sqlx::query!(
                    "delete from tb_employee where employee_id = $1",
                    &ev.employee_user.user_id
                )
                .execute(&state.postgres)
                .await
                .map_err(MyError::DBError);

                let _: () = state
                    .redis
                    .del("emp".to_owned() + &*ev.employee_id.to_string())
                    .await
                    .unwrap();
            }
            _ => {}
        }
    }
}
