use axum::extract::{Json, Query, State};
use axum::http::StatusCode;
use sqlx::{Connection, PgPool};
use sqlx::types::Uuid;

use crate::{error::MyError, model::*};

#[utoipa::path(
    get,
    path = "/api/roles",
    responses(
        (status = 200, description = "Success", body = Vec < RoleResponse >),
        (status = 404, description = "Roles not found")
    )
)]
pub async fn get_roles(State(pool): State<PgPool>) -> Result<Json<Vec<RoleResponse>>, MyError> {
    let roles: Vec<RoleResponse> = sqlx::query_as("select * from tb_role")
        .fetch_all(&pool)
        .await
        .map_err(MyError::DBError)?;

    Ok(Json(roles))
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
    State(pool): State<PgPool>,
) -> Result<Json<Vec<PositionResponse>>, MyError> {
    let poses: Vec<PositionResponse> = sqlx::query_as("select * from tb_position")
        .fetch_all(&pool)
        .await
        .map_err(MyError::DBError)?;

    Ok(Json(poses))
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
    State(pool): State<PgPool>,
    Json(pos): Json<PositionResponse>,
) -> Result<StatusCode, MyError> {
    let _ =
        sqlx::query("insert into tb_position (position_name, position_base_pay) values ($1, $2)")
            .bind(&pos.position_name)
            .bind(&pos.position_base_pay)
            .execute(&pool)
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
    State(pool): State<PgPool>,
    Json(pos): Json<PositionResponse>,
) -> Result<StatusCode, MyError> {
    let _ = sqlx::query(
        "update tb_position set position_name = $1, position_base_pay = $2 where position_id = $3",
    )
    .bind(&pos.position_name)
    .bind(&pos.position_base_pay)
    .bind(&pos.position_id)
    .execute(&pool)
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
pub async fn delete_position(State(pool): State<PgPool>, id: i32) -> Result<StatusCode, MyError> {
    let _ = sqlx::query("delete from tb_position where position_id = $1")
        .bind(&id)
        .execute(&pool)
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
pub async fn get_users(State(pool): State<PgPool>) -> Result<Json<Vec<User>>, MyError> {
    let users: Vec<UserResponse> = sqlx::query_as("select * from tb_user")
        .fetch_all(&pool)
        .await
        .map_err(MyError::DBError)?;

    let mut res: Vec<User> = Vec::new();

    let _ = users.iter().map(async move |x| {
        res.push(User {
            user_id: x.user_id,
            user_login: x.clone().user_login,
            user_password: x.clone().user_password,
            user_role: sqlx::query_as("select * from tb_role where role_id = $1")
                .bind(x.user_role_id)
                .fetch_one(&pool)
                .await?,
        })
    });

    Ok(Json(res))
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
    State(pool): State<PgPool>,
    uuid: Query<Uuid>,
) -> Result<Json<User>, MyError> {
    let user: UserResponse = sqlx::query_as("select * from tb_user where user_id = $1")
        .bind(&uuid.0)
        .fetch_one(&pool)
        .await
        .map_err(MyError::DBError)?;

    Ok(Json(User {
        user_id: user.user_id,
        user_login: user.user_login,
        user_password: user.user_password,
        user_role: sqlx::query_as("select * from tb_role where role_id = $1")
            .bind(user.user_role_id)
            .fetch_one(&pool)
            .await
            .unwrap(),
    }))
}

async fn get_user_by_cl_or_emp_id(State(pool): State<PgPool>, uuid: Uuid) -> Result<User, MyError> {
    let user: UserResponse = sqlx::query_as("select * from tb_user where user_id = $1")
        .bind(&uuid)
        .fetch_one(&pool)
        .await
        .map_err(MyError::DBError)?;

    Ok(User {
        user_id: user.user_id,
        user_login: user.user_login,
        user_password: user.user_password,
        user_role: sqlx::query_as("select * from tb_role where role_id = $1")
            .bind(user.user_role_id)
            .fetch_one(&pool)
            .await
            .unwrap(),
    })
}

#[utoipa::path(
    get,
    path = "/api/clients",
    responses(
        (status = 200, description = "Success", body = Vec < Client >),
        (status = 404, description = "Clients not found")
    )
)]
pub async fn get_clients(State(pool): State<PgPool>) -> Result<Json<Vec<Client>>, MyError> {
    let clients: Vec<ClientResponse> = sqlx::query_as("select * from tb_client")
        .fetch_all(&pool)
        .await
        .map_err(MyError::DBError)?;

    let mut res: Vec<Client> = Vec::new();
    let users = get_users(State(pool)).await.unwrap().0;

    let _ = clients.iter().map(|x| {
        res.push(Client {
            client_id: x.client_id,
            client_lastname: x.clone().client_lastname,
            client_firstname: x.clone().client_firstname,
            client_middlename: x.clone().client_middlename,
            client_user: users
                .into_iter()
                .find(|y| y.user_id == x.client_user_id)
                .unwrap(),
        })
    });

    Ok(Json(res))
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
    State(pool): State<PgPool>,
    id: Query<i32>,
) -> Result<Json<Client>, MyError> {
    let client: ClientResponse = sqlx::query_as("select * from tb_client where client_id = $1")
        .bind(&id.0)
        .fetch_one(&pool)
        .await
        .map_err(MyError::DBError)?;

    Ok(Json(Client {
        client_id: client.client_id,
        client_lastname: client.client_lastname,
        client_firstname: client.client_firstname,
        client_middlename: client.client_middlename,
        client_user: get_user_by_cl_or_emp_id(State(pool), client.client_user_id).unwrap(),
    }))
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
    State(pool): State<PgPool>,
    Json(client): Json<Client>,
) -> Result<StatusCode, MyError> {
    let mut trans = PgPool::begin(&pool).await.unwrap();

    let _ = sqlx::query("insert into tb_user (user_id, user_login, user_password, user_role_id) values ($1, $2, $3, $4)")
        .bind(&client.client_user.user_id).bind(&client.client_user.user_login).bind(&client.client_user.user_password).bind(&client.client_user.user_role.role_id)
        .execute(&pool).await.map_err(MyError::DBError)?;

    let _ = sqlx::query("insert into tb_client (client_lastname, client_firstname, client_middlename, client_user_id) values ($1, $2, $3, $4)")
        .bind(&client.client_lastname).bind(&client.client_firstname).bind(&client.client_middlename).bind(&client.client_user.user_id)
        .execute(&pool).await.map_err(MyError::DBError)?;

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
    State(pool): State<PgPool>,
    Json(client): Json<Client>,
) -> Result<StatusCode, MyError> {
    let mut trans = PgPool::begin(&pool).await.unwrap();

    let _ = sqlx::query("update tb_user set user_login = $1, user_password = $2, user_role_id = $3 where user_id = $4")
        .bind(&client.client_user.user_login).bind(&client.client_user.user_password).bind(&client.client_user.user_role.role_id).bind(&client.client_user.user_id)
        .execute(&pool).await.map_err(MyError::DBError)?;

    let _ = sqlx::query("update tb_client set client_lastname = $1, client_firstname = $2, client_middlename = $3 where client_id = $4")
        .bind(&client.client_lastname).bind(&client.client_firstname).bind(&client.client_middlename).bind(&client.client_id)
        .execute(&pool).await.map_err(MyError::DBError)?;

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
    State(pool): State<PgPool>,
    Json(client): Json<Client>,
) -> Result<StatusCode, MyError> {
    let mut trans = PgPool::begin(&pool).await.unwrap();

    let _ = sqlx::query("delete from tb_client where client_id = $1")
        .bind(&client.client_id)
        .execute(&pool)
        .await
        .map_err(MyError::DBError)?;

    let _ = sqlx::query("delete from tb_user where user_id = $1")
        .bind(&client.client_user.user_id)
        .execute(&pool)
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
pub async fn get_employees(State(pool): State<PgPool>) -> Result<Json<Vec<Employee>>, MyError> {
    let emps: Vec<EmployeeResponse> = sqlx::query_as("select * from tb_employee")
        .fetch_all(&pool)
        .await
        .map_err(MyError::DBError)?;

    let users = get_users(State(pool)).await.unwrap().0;
    let mut res: Vec<Employee> = Vec::new();

    let _ = emps.iter().map(async move |x| {
        res.push(Employee {
            employee_id: x.employee_id,
            employee_lastname: x.clone().employee_lastname,
            employee_firstname: x.clone().employee_firstname,
            employee_middlename: x.clone().employee_middlename,
            employee_position: sqlx::query_as("select * from tb_position where position_id = $1")
                .bind(&x.employee_position_id)
                .fetch_one(&pool)
                .await?,
            employee_user: users
                .into_iter()
                .find(|y| y.user_id == x.employee_user_id)
                .unwrap(),
        })
    });

    Ok(Json(res))
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
    State(pool): State<PgPool>,
    uuid: Query<Uuid>,
) -> Result<Json<Employee>, MyError> {
    let emp: EmployeeResponse = sqlx::query_as("select * from tb_employee where employee_id = $1")
        .bind(&uuid.0)
        .fetch_one(&pool)
        .await
        .map_err(MyError::DBError)?;

    Ok(Json(Employee {
        employee_id: emp.employee_id,
        employee_lastname: emp.employee_lastname,
        employee_firstname: emp.employee_firstname,
        employee_middlename: emp.employee_middlename,
        employee_position: sqlx::query_as("select * from tb_position where position_id = $1")
            .bind(&emp.employee_position_id)
            .fetch_one(&pool)
            .await
            .unwrap(),
        employee_user: get_user_by_cl_or_emp_id(State(pool), emp.employee_user_id).unwrap(),
    }))
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
    State(pool): State<PgPool>,
    Json(emp): Json<Employee>,
) -> Result<StatusCode, MyError> {
    let mut trans = PgPool::begin(&pool).await.unwrap();

    let _ = sqlx::query("insert into tb_user (user_id, user_login, user_password, user_role_id) values ($1, $2, $3, $4)")
        .bind(&emp.employee_user.user_id).bind(&emp.employee_user.user_login).bind(&emp.employee_user.user_password).bind(&emp.employee_user.user_role.role_id)
        .execute(&pool).await.map_err(MyError::DBError)?;

    let _ = sqlx::query("insert into tb_employee (employee_lastname, employee_firstname, employee_middlename, employee_position_id, employee_user_id) values ($1, $2, $3, $4, $5)")
        .bind(&emp.employee_lastname).bind(&emp.employee_firstname).bind(&emp.employee_middlename).bind(&emp.employee_position.position_id).bind(&emp.employee_user.user_id)
        .execute(&pool).await.map_err(MyError::DBError)?;

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
    State(pool): State<PgPool>,
    Json(emp): Json<Employee>,
) -> Result<StatusCode, MyError> {
    let mut trans = PgPool::begin(&pool).await.unwrap();

    let _ = sqlx::query("update tb_user set user_login = $1, user_password = $2, user_role_id = $3 where user_id = $4")
        .bind(&emp.employee_user.user_login).bind(&emp.employee_user.user_password).bind(&emp.employee_user.user_role.role_id).bind(&emp.employee_user.user_id)
        .execute(&pool).await.map_err(MyError::DBError)?;

    let _ = sqlx::query("update tb_employee set employee_lastname = $1, employee_firstname = $2, employee_middlename = $3, employee_position_id = $4 where employee_id = $5")
        .bind(&emp.employee_lastname).bind(&emp.employee_firstname).bind(&emp.employee_middlename).bind(&emp.employee_position.position_id).bind(&emp.employee_id)
        .execute(&pool).await.map_err(MyError::DBError)?;

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
    State(pool): State<PgPool>,
    Json(emp): Json<Employee>,
) -> Result<StatusCode, MyError> {
    let mut trans = PgPool::begin(&pool).await.unwrap();

    let _ = sqlx::query("delete from tb_employee where employee_id = $1")
        .bind(&emp.employee_id)
        .execute(&pool)
        .await
        .map_err(MyError::DBError)?;

    let _ = sqlx::query("delete from tb_user where user_id = $1")
        .bind(&emp.employee_user.user_id)
        .execute(&pool)
        .await
        .map_err(MyError::DBError)?;

    trans.commit().await.unwrap();

    Ok(StatusCode::CREATED)
}
