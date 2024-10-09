-- A LOT OF WORK HERE!!!

create table if not exists tb_package_type
(
	type_id smallserial primary key,
	type_name varchar(20) not null,
	type_length int not null,
	type_width int not null,
	type_height int not null,
	type_weight int not null
);

create table if not exists tb_package_status
(
	status_id smallserial primary key,
	status_name varchar(30) not null
);

create table if not exists tb_package
(
	package_uuid uuid primary key,
	package_transport_id serial not null,
	package_type_id smallint not null,
	package_status_id smallint not null,
	package_sender_id int not null,
	foreign key (package_type_id) references tb_package_type (type_id),
	foreign key (package_status_id) references tb_package_status (status_id)
);

create table if not exists tb_package_items
(
	package_id uuid not null,
	item_name varchar(25) not null,
	item_length decimal(5, 1) not null,
	item_width decimal(5, 1) not null,
	item_heigth decimal(5, 1) not null,
	item_weight decimal(6, 1) not null,
	foreign key (package_id) references tb_package (package_uuid)
);

create table if not exists tb_service
(

);