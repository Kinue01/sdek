create database transports;

create table if not exists tb_transport_type
(
	type_id smallserial primary key,
	type_name varchar(20) not null
);

create table if not exists tb_transport
(
	transport_id serial primary key,
	transport_name varchar(50) not null,
	transport_type_id smallint not null,
	transport_driver_id uuid not null,
	foreign key (transport_type_id) references tb_transport_type (type_id)
)