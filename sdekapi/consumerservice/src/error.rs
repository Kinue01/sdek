use axum::{body, http::StatusCode, response::{IntoResponse, Response}, Error};
use derive_more::Display;

#[derive(Debug, Display)]
pub enum MyError {
    Error(Error)
}

impl IntoResponse for MyError {
    fn into_response(self) -> Response {
        match self {
            MyError::Error(ref err) => Response::builder()
                .status(StatusCode::INTERNAL_SERVER_ERROR)
                .body(body::Body::from(err.to_string()))
                .unwrap(),
        }
    }
}
