create database transports;

drop database transports;

create table if not exists tb_transport_type
(
	type_id smallserial primary key,
	type_name varchar(20) not null
);

create table if not exists tb_transport_status
(
	status_id smallserial primary key,
	status_name varchar(20) not null
);

create table if not exists tb_transport
(
	transport_id serial primary key,
	transport_name varchar(50) not null,
	transport_reg_number varchar(6) not null,
	transport_type_id smallint not null,
	transport_status_id smallint not null,
	foreign key (transport_type_id) references tb_transport_type (type_id),
	foreign key (transport_status_id) references tb_transport_status (status_id)
);