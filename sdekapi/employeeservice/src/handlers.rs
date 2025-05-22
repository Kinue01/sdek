use axum::extract::State;
use axum::http::StatusCode;
use axum::Json;
use eventstore::EventData;

use crate::error::MyError;
use crate::model::*;
use crate::AppState;

#[utoipa::path(
    post,
    path = "/api/employee",
    request_body(content = Employee, description = "Employee"),
    responses(
        (status = 201, description = "Employee created"),
        (status = 500, description = "Can`t create employee")
    )
)]
pub async fn add_employee(
    State(state): State<AppState>,
    Json(emp): Json<Employee>,
) -> Result<StatusCode, MyError> {
    let user_event = EventData::json("user_add", &emp.employee_user).unwrap();
    let emp_event = EventData::json("employee_add", &emp).unwrap();

    let _ = state
        .event_client
        .append_to_stream("user", &Default::default(), user_event)
        .await
        .unwrap();
    let _ = state
        .event_client
        .append_to_stream("employee", &Default::default(), emp_event)
        .await
        .unwrap();

    Ok(StatusCode::CREATED)
}

#[utoipa::path(
    patch,
    path = "/api/employee",
    request_body(content = Employee, description = "Employee"),
    responses(
        (status = 200, description = "Employee updated"),
        (status = 500, description = "Can`t update employee")
    )
)]
pub async fn update_employee(
    State(state): State<AppState>,
    Json(emp): Json<Employee>,
) -> Result<StatusCode, MyError> {
    let user_event = EventData::json("user_update", &emp.employee_user).unwrap();
    let emp_event = EventData::json("employee_update", &emp).unwrap();

    let _ = state
        .event_client
        .append_to_stream("user", &Default::default(), user_event)
        .await
        .unwrap();
    let _ = state
        .event_client
        .append_to_stream("employee", &Default::default(), emp_event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

#[utoipa::path(
    delete,
    path = "/api/employee",
    request_body(content = Employee, description = "Employee"),
    responses(
        (status = 200, description = "Employee deleted"),
        (status = 500, description = "Can`t delete employee")
    )
)]
pub async fn delete_employee(
    State(state): State<AppState>,
    Json(emp): Json<Employee>,
) -> Result<StatusCode, MyError> {
    let user_event = EventData::json("user_delete", &emp.employee_user).unwrap();
    let emp_event = EventData::json("employee_delete", &emp).unwrap();

    let _ = state
        .event_client
        .append_to_stream("employee", &Default::default(), emp_event)
        .await
        .unwrap();
    let _ = state
        .event_client
        .append_to_stream("user", &Default::default(), user_event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

#[utoipa::path(
    post,
    path = "/api/position",
    request_body(content = PositionResponse, description = "Position"),
    responses(
        (status = 201, description = "Position created"),
        (status = 500, description = "Can`t create position")
    )
)]
pub async fn add_position(
    State(state): State<AppState>,
    Json(pos): Json<PositionResponse>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("position_add", &pos).unwrap();
    let _ = state
        .event_client
        .append_to_stream("position", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::CREATED)
}

#[utoipa::path(
    patch,
    path = "/api/position",
    request_body(content = PositionResponse, description = "Position"),
    responses(
        (status = 200, description = "Position updated"),
        (status = 500, description = "Can`t update position")
    )
)]
pub async fn update_position(
    State(state): State<AppState>,
    Json(pos): Json<PositionResponse>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("position_update", &pos).unwrap();
    let _ = state
        .event_client
        .append_to_stream("position", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

#[utoipa::path(
    delete,
    path = "/api/position",
    request_body(content = i32, description = "Position id"),
    responses(
        (status = 200, description = "Position deleted"),
        (status = 500, description = "Can`t delete position")
    )
)]
pub async fn delete_position(
    State(state): State<AppState>,
    Json(pos): Json<PositionResponse>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("position_delete", &pos).unwrap();
    let _ = state
        .event_client
        .append_to_stream("position", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}
