use axum::extract::{Query, State};
use axum::Json;
use futures::StreamExt;
use redis::{JsonAsyncCommands};
use serde::Deserialize;
use std::clone::Clone;
use utoipa::IntoParams;
use uuid::Uuid;

use crate::error::MyError;
use crate::model::*;
use crate::AppState;

#[utoipa::path(
    get,
    path = "/api/employees",
    responses(
        (status = 200, description = "Success", body = Vec < Employee >),
        (status = 404, description = "Employees not found")
    )
)]
pub async fn get_employees(
    State(state): State<AppState>,
) -> Result<Json<Vec<Employee>>, MyError> {
    let emps = sqlx::query_as!(EmployeeResponse, "select * from tb_employee")
        .fetch_all(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    let res = futures::stream::iter(emps)
        .map(|x| async {
            let postgres = state.postgres.clone();

            tokio::spawn(async move {
                let user = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &x.clone().employee_user_id)
                    .fetch_one(&postgres)
                    .await
                    .map_err(MyError::DBError).unwrap();

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
                        user_email: user.user_email.expect("REASON"),
                        user_phone: user.user_phone,
                        user_access_token: user.user_access_token.expect("REASON"),
                        user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", user.user_role_id)
                            .fetch_one(&postgres)
                            .await
                            .map_err(MyError::DBError).expect("REASON"),
                    },
                }
            })
                .await
                .unwrap_or_default()
        })
        .buffer_unordered(24)
        .collect::<Vec<_>>()
        .await;

    Ok(Json(res))
}

#[derive(Deserialize, IntoParams)]
pub struct EmpSearchQuery {
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
    State(state): State<AppState>,
    uuid: Query<EmpSearchQuery>,
) -> Result<Json<Employee>, MyError> {
    let emp = sqlx::query_as!(
                EmployeeResponse,
                "select * from tb_employee where employee_id = $1",
                &uuid.0.uuid
            )
        .fetch_one(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    let user = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", &emp.employee_user_id)
        .fetch_one(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    Ok(
        Json(
            Employee {
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
                employee_user: User {
                    user_id: user.user_id,
                    user_login: user.user_login,
                    user_password: user.user_password,
                    user_email: user.user_email.expect("REASON"),
                    user_phone: user.user_phone,
                    user_access_token: user.user_access_token.expect("REASON"),
                    user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", user.user_role_id)
                        .fetch_one(&state.postgres)
                        .await
                        .map_err(MyError::DBError)?,
                },
            }
        )
    )
}

#[derive(Deserialize, IntoParams)]
pub struct GetEmpByUuid {
    uuid: Uuid,
}

pub async fn get_employee_by_user_id(
    State(state): State<AppState>,
    uuid: Query<GetEmpByUuid>,
) -> Result<Json<Employee>, MyError> {
    let emp = sqlx::query!(
        "select employee_id from tb_employee where employee_user_id = $1",
        uuid.uuid
    )
    .fetch_one(&state.postgres)
    .await
    .map_err(MyError::DBError)?;

    let emp = sqlx::query_as!(EmployeeResponse, "select * from tb_employee where employee_id = $1", &emp.employee_id)
        .fetch_one(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    let user = sqlx::query_as!(UserResponse, "select * from tb_fuser where user_id = $1", emp.employee_user_id)
        .fetch_one(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    Ok(
        Json(
            Employee {
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
                employee_user: User {
                    user_id: user.user_id,
                    user_login: user.user_login,
                    user_password: user.user_password,
                    user_email: user.user_email.expect("REASON"),
                    user_phone: user.user_phone,
                    user_access_token: user.user_access_token.expect("REASON"),
                    user_role: sqlx::query_as!(RoleResponse, "select * from tb_fuser_role where role_id = $1", user.user_role_id)
                        .fetch_one(&state.postgres)
                        .await
                        .map_err(MyError::DBError)?,
                },
            }
        )
    )
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
    State(state): State<AppState>,
) -> Result<Json<Vec<PositionResponse>>, MyError> {
    let poses = sqlx::query_as!(PositionResponse, "select * from tb_position")
        .fetch_all(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    Ok(Json(poses))
}

#[derive(Deserialize, IntoParams)]
pub struct PosSearchQuery {
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
    State(state): State<AppState>,
    id: Query<PosSearchQuery>,
) -> Result<Json<PositionResponse>, MyError> {
    let pos = sqlx::query_as!(
                PositionResponse,
                "select * from tb_position where position_id = $1",
                id.id
            )
        .fetch_one(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    Ok(Json(pos))
}

pub async fn update_db_poses(State(mut state): State<AppState>) {
    let mut stream = state
        .event_client
        .subscribe_to_stream("position", &Default::default())
        .await;

    loop {
        let e = stream.next().await;
        
        let event = match e { 
            Ok(e) => e,
            Err(_e) => continue,
        };
        
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
                    .map_err(MyError::DBError)
                    .unwrap();
            }
            "position_update" => {
                let _ = sqlx::query!("update tb_position set position_name = $1, position_base_pay = $2 where position_id = $3", &ev.position_name, &ev.position_base_pay, &ev.position_id)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();
            }
            "position_delete" => {
                let _ = sqlx::query!(
                    "delete from tb_position where position_id = $1",
                    &ev.position_id
                )
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();
            }
            _ => {}
        }
    }
}

pub async fn update_db_main(State(mut state): State<AppState>) {
    let mut stream = state
        .event_client
        .subscribe_to_stream("employee", &Default::default())
        .await;

    loop {
        let e = stream.next().await;
        
        let event = match e { 
            Ok(e) => e,
            Err(_e) => continue
        };
        
        let ev = event.get_original_event().as_json::<Employee>().unwrap();
        
        match event.event.unwrap().event_type.as_str() {
            "employee_add" => {
                let _ = sqlx::query!("insert into tb_employee (employee_lastname, employee_firstname, employee_middlename, employee_position_id, employee_user_id) values ($1, $2, $3, $4, $5)", &ev.employee_lastname, &ev.employee_firstname, &ev.employee_middlename, &ev.employee_position.position_id, &ev.employee_user.user_id)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();
            }
            "employee_update" => {
                let _ = sqlx::query!("update tb_employee set employee_lastname = $1, employee_firstname = $2, employee_middlename = $3, employee_position_id = $4, employee_user_id = $5 where employee_id = $6", &ev.employee_lastname, &ev.employee_firstname, &ev.employee_middlename, &ev.employee_position.position_id, &ev.employee_user.user_id, &ev.employee_id)
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();
            }
            "employee_delete" => {
                let _ = sqlx::query!(
                    "delete from tb_employee where employee_id = $1",
                    &ev.employee_user.user_id
                )
                    .execute(&state.postgres)
                    .await
                    .map_err(MyError::DBError)
                    .unwrap();
            }
            _ => {}
        }
    }
}
