use axum::{
    body,
    http::StatusCode,
    response::{IntoResponse, Response},
};
use derive_more::Display;
use redis::RedisError;
use sqlx::error::Error;

#[derive(Debug, Display)]
pub enum MyError {
    DBError(Error),
    RDbError(RedisError),
}

impl IntoResponse for MyError {
    fn into_response(self) -> Response {
        match self {
            MyError::DBError(ref err) => Response::builder()
                .status(StatusCode::INTERNAL_SERVER_ERROR)
                .body(body::Body::from(err.to_string()))
                .unwrap(),
            MyError::RDbError(ref err) => Response::builder()
                .status(StatusCode::BAD_REQUEST)
                .body(body::Body::from(err.to_string()))
                .unwrap(),
        }
    }
}
