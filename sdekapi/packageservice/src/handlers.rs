use axum::extract::State;
use axum::http::StatusCode;
use axum::Json;
use eventstore::{Client, EventData};

use crate::error::MyError;
use crate::model::*;

pub async fn add_package_type(
    State(state): State<Client>,
    Json(p_type): Json<PackageType>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("package_type_add", p_type).unwrap();

    let _ = state
        .append_to_stream("package_type", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::CREATED)
}

pub async fn update_package_type(
    State(state): State<Client>,
    Json(p_type): Json<PackageType>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("package_type_update", p_type).unwrap();

    let _ = state
        .append_to_stream("package_type", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

pub async fn delete_package_type(
    State(state): State<Client>,
    Json(p_type): Json<PackageType>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("package_type_delete", p_type).unwrap();

    let _ = state
        .append_to_stream("package_type", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

pub async fn add_package_status(
    State(state): State<Client>,
    Json(p_status): Json<PackageStatus>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("package_status_add", p_status).unwrap();

    let _ = state
        .append_to_stream("package_status", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::CREATED)
}

pub async fn update_package_status(
    State(state): State<Client>,
    Json(p_status): Json<PackageStatus>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("package_status_update", p_status).unwrap();

    let _ = state
        .append_to_stream("package_status", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

pub async fn delete_package_status(
    State(state): State<Client>,
    Json(p_status): Json<PackageStatus>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("package_status_delete", p_status).unwrap();

    let _ = state
        .append_to_stream("package_status", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

pub async fn add_package(
    State(state): State<Client>,
    Json(package): Json<Package>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("package_add", package).unwrap();

    let _ = state
        .append_to_stream("package", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::CREATED)
}

pub async fn update_package(
    State(state): State<Client>,
    Json(package): Json<Package>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("package_update", package).unwrap();

    let _ = state
        .append_to_stream("package", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}

pub async fn delete_package(
    State(state): State<Client>,
    Json(package): Json<Package>,
) -> Result<StatusCode, MyError> {
    let event = EventData::json("package_delete", package).unwrap();

    let _ = state
        .append_to_stream("package", &Default::default(), event)
        .await
        .unwrap();

    Ok(StatusCode::OK)
}
