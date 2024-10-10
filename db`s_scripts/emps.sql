create database employees;

create table if not exists tb_position
(
	position_id smallserial primary key,
	position_name varchar(20) not null,
	position_base_pay int not null
);

create table if not exists tb_employee
(
	employee_id uuid primary key,
	employee_lastname varchar(40) not null,
	employee_firstname varchar(30) not null,
	employee_middlename varchar(50) not null,
	employee_position_id smallint not null,
	employee_user_id uuid not null,
	foreign key (employee_position_id) references tb_position (position_id)
);