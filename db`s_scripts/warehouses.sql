create database warehouses;

create extension postgis;

create table if not exists tb_warehouse_type
(
	type_id smallserial primary key,
	type_name varchar(50) not null,
	type_small_quantity int not null,
	type_med_quantity int not null,
	type_huge_quantity int not null
);

create table if not exists tb_warehouse
(
	warehouse_id serial primary key,
	warehouse_name varchar(150) not null,
	warehouse_address varchar(350) not null,
	warehouse_point GEOGRAPHY(Point) not null,
	warehouse_type_id smallint not null,
	foreign key (warehouse_type_id) references tb_warehouse_type (type_id)
);