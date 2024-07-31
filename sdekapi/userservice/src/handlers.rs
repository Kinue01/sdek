use axum::extract::{Json, Query, State};
use axum::http::StatusCode;
use redis::AsyncCommands;
use sqlx::PgPool;
use uuid::Uuid;

use crate::{AppState, error::MyError, model::*};

#[utoipa::path(
    get,
    path = "/api/roles",
    responses(
        (status = 200, description = "Success", body = Vec < RoleResponse >),
        (status = 404, description = "Roles not found")
    )
)]
pub async fn get_roles(
    State(mut state): State<AppState>,
) -> Result<Json<Vec<RoleResponse>>, MyError> {
    let roles_redis: Vec<RoleResponse> =
        state.redis.get("roles").await.map_err(MyError::RDbError)?;

    match roles_redis.is_empty() {
        true => {
            let roles: Vec<RoleResponse> = sqlx::query_as("select * from tb_role")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let _: () = state
                .redis
                .set("roles", &roles)
                .await
                .map_err(MyError::RDbError)?;

            Ok(Json(roles))
        }
        false => Ok(Json(roles_redis)),
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
            let poses: Vec<PositionResponse> = sqlx::query_as("select * from tb_position")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let _: () = state
                .redis
                .set("poses", &poses)
                .await
                .map_err(MyError::RDbError)?;

            Ok(Json(poses))
        }
        false => Ok(Json(poses_redis)),
    }
}

#[utoipa::path(
    post,
    path = "/api/positions",
    responses(
        (status = 201, description = "Position created"),
        (status = 500, description = "Can`t create position")
    )
)]
pub async fn add_position(
    State(state): State<AppState>,
    Json(pos): Json<PositionResponse>,
) -> Result<StatusCode, MyError> {
    let _ =
        sqlx::query("insert into tb_position (position_name, position_base_pay) values ($1, $2)")
            .bind(&pos.position_name)
            .bind(&pos.position_base_pay)
            .execute(&state.postgres)
            .await
            .map_err(MyError::DBError)?;

    Ok(StatusCode::CREATED)
}

#[utoipa::path(
    patch,
    path = "/api/positions",
    responses(
        (status = 200, description = "Position updated"),
        (status = 500, description = "Can`t update position")
    )
)]
pub async fn update_position(
    State(state): State<AppState>,
    Json(pos): Json<PositionResponse>,
) -> Result<StatusCode, MyError> {
    let _ = sqlx::query(
        "update tb_position set position_name = $1, position_base_pay = $2 where position_id = $3",
    )
    .bind(&pos.position_name)
    .bind(&pos.position_base_pay)
    .bind(&pos.position_id)
    .execute(&state.postgres)
    .await
    .map_err(MyError::DBError)?;

    Ok(StatusCode::OK)
}

#[utoipa::path(
    delete,
    path = "/api/positions",
    responses(
        (status = 200, description = "Position deleted"),
        (status = 500, description = "Can`t delete position")
    )
)]
pub async fn delete_position(
    State(state): State<AppState>,
    Json(id): Json<i32>,
) -> Result<StatusCode, MyError> {
    let _ = sqlx::query("delete from tb_position where position_id = $1")
        .bind(&id)
        .execute(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    Ok(StatusCode::OK)
}

#[utoipa::path(
    get,
    path = "/api/users",
    responses(
        (status = 200, description = "Success", body = Vec < User >),
        (status = 404, description = "Users not found")
    )
)]
pub async fn get_users(State(mut state): State<AppState>) -> Result<Json<Vec<User>>, MyError> {
    let users_redis: Vec<User> = state.redis.get("users").await.map_err(MyError::RDbError)?;

    match users_redis.is_empty() {
        true => {
            let users: Vec<UserResponse> = sqlx::query_as("select * from tb_user")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let roles = get_roles(State(state.clone())).await.unwrap_or_default().0;
            let mut res: Vec<User> = Vec::new();

            let _ = users.iter().map(|x| {
                res.push(User {
                    user_id: x.user_id,
                    user_login: x.clone().user_login,
                    user_password: x.clone().user_password,
                    user_role: roles
                        .clone()
                        .into_iter()
                        .find(|y| x.user_role_id == y.role_id)
                        .unwrap_or_default(),
                })
            });

            let _: () = state
                .redis
                .set("users", &res)
                .await
                .map_err(MyError::RDbError)?;

            Ok(Json(res))
        }
        false => Ok(Json(users_redis)),
    }
}

#[utoipa::path(
    get,
    path = "/api/user",
    responses(
        (status = 200, description = "Ok", body = User),
        (status = 404, description = "User not found")
    )
)]
pub async fn get_user_by_id(
    State(mut state): State<AppState>,
    Query(uuid): Query<Uuid>,
) -> Result<Json<User>, MyError> {
    let user_redis: User = state
        .redis
        .get("user".to_owned() + &*uuid.to_string())
        .await
        .map_err(MyError::RDbError)?;

    match user_redis.user_id {
        u if u == Uuid::default() => {
            let user: UserResponse = sqlx::query_as("select * from tb_user where user_id = $1")
                .bind(&uuid)
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let res = User {
                user_id: user.user_id,
                user_login: user.user_login,
                user_password: user.user_password,
                user_role: sqlx::query_as("select * from tb_role where role_id = $1")
                    .bind(user.user_role_id)
                    .fetch_one(&state.postgres)
                    .await
                    .map_err(MyError::DBError)?,
            };

            let _: () = state
                .redis
                .set("user".to_owned() + &*uuid.to_string(), &res)
                .await
                .map_err(MyError::RDbError)?;

            Ok(Json(res))
        }
        _ => Ok(Json(user_redis)),
    }
}

#[utoipa::path(
    get,
    path = "/api/clients",
    responses(
        (status = 200, description = "Success", body = Vec < Client >),
        (status = 404, description = "Clients not found")
    )
)]
pub async fn get_clients(State(mut state): State<AppState>) -> Result<Json<Vec<Client>>, MyError> {
    let clients_redis: Vec<Client> = state
        .redis
        .get("clients")
        .await
        .map_err(MyError::RDbError)?;

    match clients_redis.is_empty() {
        true => Ok(Json(clients_redis)),
        false => {
            let clients: Vec<ClientResponse> = sqlx::query_as("select * from tb_client")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let mut res: Vec<Client> = Vec::new();
            let users = get_users(State(state.clone())).await.unwrap().0;

            let _ = clients.iter().map(|x| {
                res.push(Client {
                    client_id: x.client_id,
                    client_lastname: x.clone().client_lastname,
                    client_firstname: x.clone().client_firstname,
                    client_middlename: x.clone().client_middlename,
                    client_user: users
                        .clone()
                        .into_iter()
                        .find(|y| x.client_user_id == y.user_id)
                        .unwrap(),
                })
            });

            let _: () = state
                .redis
                .set("clients", &res)
                .await
                .map_err(MyError::RDbError)?;

            Ok(Json(res))
        }
    }
}

#[utoipa::path(
    get,
    path = "/api/client",
    responses(
        (status = 200, description = "Ok", body = Client),
        (status = 404, description = "Client not found")
    )
)]
pub async fn get_client_by_id(
    State(mut state): State<AppState>,
    Query(id): Query<i32>,
) -> Result<Json<Client>, MyError> {
    let client_redis: Client = state
        .redis
        .get("client".to_owned() + &*id.to_string())
        .await
        .map_err(MyError::RDbError)?;

    match client_redis.client_id {
        0 => {
            let client: ClientResponse =
                sqlx::query_as("select * from tb_client where client_id = $1")
                    .bind(&id)
                    .fetch_one(&state.postgres)
                    .await
                    .map_err(MyError::DBError)?;

            let user = get_user_by_id(State(state.clone()), Query(client.client_user_id))
                .await
                .unwrap()
                .0;
            let res = Client {
                client_id: client.client_id,
                client_lastname: client.client_lastname,
                client_firstname: client.client_firstname,
                client_middlename: client.client_middlename,
                client_user: user,
            };

            let _: () = state
                .redis
                .set("client".to_owned() + &*id.to_string(), &res)
                .await
                .map_err(MyError::RDbError)?;

            Ok(Json(res))
        }
        _ => Ok(Json(client_redis)),
    }
}

#[utoipa::path(
    post,
    path = "/api/clients",
    responses(
        (status =  201, description = "Client created"),
        (status = 500, description = "Can`t create client")
    )
)]
pub async fn add_client(
    State(state): State<AppState>,
    Json(client): Json<Client>,
) -> Result<StatusCode, MyError> {
    let trans = PgPool::begin(&state.postgres).await.unwrap();

    let _ = sqlx::query("insert into tb_user (user_id, user_login, user_password, user_role_id) values ($1, $2, $3, $4)")
        .bind(&client.client_user.user_id).bind(&client.client_user.user_login).bind(&client.client_user.user_password).bind(&client.client_user.user_role.role_id)
        .execute(&state.postgres).await.map_err(MyError::DBError)?;

    let _ = sqlx::query("insert into tb_client (client_lastname, client_firstname, client_middlename, client_user_id) values ($1, $2, $3, $4)")
        .bind(&client.client_lastname).bind(&client.client_firstname).bind(&client.client_middlename).bind(&client.client_user.user_id)
        .execute(&state.postgres).await.map_err(MyError::DBError)?;

    trans.commit().await.unwrap();

    Ok(StatusCode::CREATED)
}

#[utoipa::path(
    patch,
    path = "/api/clients",
    responses(
        (status = 200, description = "Client updated"),
        (status = 500, description = "Can`t update client")
    )
)]
pub async fn update_client(
    State(state): State<AppState>,
    Json(client): Json<Client>,
) -> Result<StatusCode, MyError> {
    let trans = PgPool::begin(&state.postgres).await.unwrap();

    let _ = sqlx::query("update tb_user set user_login = $1, user_password = $2, user_role_id = $3 where user_id = $4")
        .bind(&client.client_user.user_login).bind(&client.client_user.user_password).bind(&client.client_user.user_role.role_id).bind(&client.client_user.user_id)
        .execute(&state.postgres).await.map_err(MyError::DBError)?;

    let _ = sqlx::query("update tb_client set client_lastname = $1, client_firstname = $2, client_middlename = $3 where client_id = $4")
        .bind(&client.client_lastname).bind(&client.client_firstname).bind(&client.client_middlename).bind(&client.client_id)
        .execute(&state.postgres).await.map_err(MyError::DBError)?;

    trans.commit().await.unwrap();

    Ok(StatusCode::OK)
}

#[utoipa::path(
    delete,
    path = "/api/clients",
    responses(
        (status = 200, description = "Client deleted"),
        (status = 500, description = "Can`t delete client")
    )
)]
pub async fn delete_client(
    State(state): State<AppState>,
    Json(client): Json<Client>,
) -> Result<StatusCode, MyError> {
    let trans = PgPool::begin(&state.postgres).await.unwrap();

    let _ = sqlx::query("delete from tb_client where client_id = $1")
        .bind(&client.client_id)
        .execute(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    let _ = sqlx::query("delete from tb_user where user_id = $1")
        .bind(&client.client_user.user_id)
        .execute(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    trans.commit().await.unwrap();

    Ok(StatusCode::OK)
}

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
    let emps_redis: Vec<Employee> = state.redis.get("emps").await.map_err(MyError::RDbError)?;

    match emps_redis.is_empty() {
        true => {
            let emps: Vec<EmployeeResponse> = sqlx::query_as("select * from tb_employee")
                .fetch_all(&state.postgres)
                .await
                .map_err(MyError::DBError)?;

            let users = get_users(State(state.clone())).await.unwrap().0;
            let mut res: Vec<Employee> = Vec::new();
            let poses = get_positions(State(state.clone()))
                .await
                .unwrap_or_default()
                .0;

            let _ = emps.iter().map(|x| {
                res.push(Employee {
                    employee_id: x.employee_id,
                    employee_lastname: x.clone().employee_lastname,
                    employee_firstname: x.clone().employee_firstname,
                    employee_middlename: x.clone().employee_middlename,
                    employee_position: poses
                        .clone()
                        .into_iter()
                        .find(|y| x.employee_position_id == y.position_id)
                        .unwrap_or_default(),
                    employee_user: users
                        .clone()
                        .into_iter()
                        .find(|y| y.user_id == x.employee_user_id)
                        .unwrap_or_default(),
                })
            });

            let _: () = state
                .redis
                .set("emps", &res)
                .await
                .map_err(MyError::RDbError)?;

            Ok(Json(res))
        }
        false => Ok(Json(emps_redis)),
    }
}

#[utoipa::path(
    get,
    path = "/api/employee",
    responses(
        (status = 200, description = "Ok", body = Employee),
        (status = 404, description = "Employee not found")
    )
)]
pub async fn get_employee_by_id(
    State(mut state): State<AppState>,
    Query(uuid): Query<Uuid>,
) -> Result<Json<Employee>, MyError> {
    let emp_redis: Employee = state
        .redis
        .get("emp".to_owned() + &*uuid.to_string())
        .await
        .map_err(MyError::RDbError)?;

    match emp_redis.employee_id {
        u if u == Uuid::default() => {
            let emp: EmployeeResponse =
                sqlx::query_as("select * from tb_employee where employee_id = $1")
                    .bind(&uuid)
                    .fetch_one(&state.postgres)
                    .await
                    .map_err(MyError::DBError)?;

            let user = get_user_by_id(State(state.clone()), Query(emp.employee_user_id))
                .await
                .unwrap()
                .0;

            let res = Employee {
                employee_id: emp.employee_id,
                employee_lastname: emp.employee_lastname,
                employee_firstname: emp.employee_firstname,
                employee_middlename: emp.employee_middlename,
                employee_position: sqlx::query_as(
                    "select * from tb_position where position_id = $1",
                )
                .bind(&emp.employee_position_id)
                .fetch_one(&state.postgres)
                .await
                .map_err(MyError::DBError)?,
                employee_user: user,
            };

            let _: () = state
                .redis
                .set("emp".to_owned() + &*uuid.to_string(), &res)
                .await
                .map_err(MyError::RDbError)?;

            Ok(Json(res))
        }
        _ => Ok(Json(emp_redis)),
    }
}

#[utoipa::path(
    post,
    path = "/api/employees",
    responses(
        (status = 201, description = "Employee created"),
        (status = 500, description = "Can`t create employee")
    )
)]
pub async fn add_employee(
    State(state): State<AppState>,
    Json(emp): Json<Employee>,
) -> Result<StatusCode, MyError> {
    let trans = PgPool::begin(&state.postgres).await.unwrap();

    let _ = sqlx::query("insert into tb_user (user_id, user_login, user_password, user_role_id) values ($1, $2, $3, $4)")
        .bind(&emp.employee_user.user_id).bind(&emp.employee_user.user_login).bind(&emp.employee_user.user_password).bind(&emp.employee_user.user_role.role_id)
        .execute(&state.postgres).await.map_err(MyError::DBError)?;

    let _ = sqlx::query("insert into tb_employee (employee_lastname, employee_firstname, employee_middlename, employee_position_id, employee_user_id) values ($1, $2, $3, $4, $5)")
        .bind(&emp.employee_lastname).bind(&emp.employee_firstname).bind(&emp.employee_middlename).bind(&emp.employee_position.position_id).bind(&emp.employee_user.user_id)
        .execute(&state.postgres).await.map_err(MyError::DBError)?;

    trans.commit().await.unwrap();

    Ok(StatusCode::CREATED)
}

#[utoipa::path(
    patch,
    path = "/api/employees",
    responses(
        (status = 200, description = "Employee updated"),
        (status = 500, description = "Can`t update employee")
    )
)]
pub async fn update_employee(
    State(state): State<AppState>,
    Json(emp): Json<Employee>,
) -> Result<StatusCode, MyError> {
    let trans = PgPool::begin(&state.postgres).await.unwrap();

    let _ = sqlx::query("update tb_user set user_login = $1, user_password = $2, user_role_id = $3 where user_id = $4")
        .bind(&emp.employee_user.user_login).bind(&emp.employee_user.user_password).bind(&emp.employee_user.user_role.role_id).bind(&emp.employee_user.user_id)
        .execute(&state.postgres).await.map_err(MyError::DBError)?;

    let _ = sqlx::query("update tb_employee set employee_lastname = $1, employee_firstname = $2, employee_middlename = $3, employee_position_id = $4 where employee_id = $5")
        .bind(&emp.employee_lastname).bind(&emp.employee_firstname).bind(&emp.employee_middlename).bind(&emp.employee_position.position_id).bind(&emp.employee_id)
        .execute(&state.postgres).await.map_err(MyError::DBError)?;

    trans.commit().await.unwrap();

    Ok(StatusCode::CREATED)
}

#[utoipa::path(
    delete,
    path = "/api/employees",
    responses(
        (status = 200, description = "Employee deleted"),
        (status = 500, description = "Can`t delete employee")
    )
)]
pub async fn delete_employee(
    State(state): State<AppState>,
    Json(emp): Json<Employee>,
) -> Result<StatusCode, MyError> {
    let trans = PgPool::begin(&state.postgres).await.unwrap();

    let _ = sqlx::query("delete from tb_employee where employee_id = $1")
        .bind(&emp.employee_id)
        .execute(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    let _ = sqlx::query("delete from tb_user where user_id = $1")
        .bind(&emp.employee_user.user_id)
        .execute(&state.postgres)
        .await
        .map_err(MyError::DBError)?;

    trans.commit().await.unwrap();

    Ok(StatusCode::CREATED)
}
