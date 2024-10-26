create database packages;

drop database packages;

create extension postgres_fdw;
create extension postgis;

create table if not exists tb_package_type
(
	type_id smallserial primary key,
	type_name varchar(20) not null,
	type_length int not null,
	type_width int not null,
	type_height int not null
);

create table if not exists tb_package_status
(
	status_id smallserial primary key,
	status_name varchar(30) not null
);

create table if not exists tb_package_paytype
(
	type_id smallint primary key,
	type_name varchar(40) not null
);
create table if not exists tb_package_payer
(
	payer_id smallint primary key,
	payer_name varchar(40) not null
);

create table if not exists tb_package
(
	package_uuid uuid primary key,
	package_send_date date,
	package_receive_date date,
	package_weight decimal(7, 3),
	package_deliveryperson_id int not null,
	package_type_id smallint not null,
	package_status_id smallint not null,
	package_sender_id int not null,
	package_receiver_id int not null,
	package_warehouse_id int not null,
	package_paytype_id smallint not null,
	package_payer_id smallint not null,
	foreign key (package_type_id) references tb_package_type (type_id),
	foreign key (package_status_id) references tb_package_status (status_id),
	foreign key (package_paytype_id) references tb_package_paytype (type_id),
	foreign key (package_payer_id) references tb_package_payer (payer_id)
);

create server fdelivery_personell foreign data wrapper postgres_fdw options (host 'localhost', dbname 'delivery_personell');

create user mapping for current_user server fdelivery_personell options (user 'postgres', password '1');

create foreign table tb_fdelivery_person
(
	person_id integer NOT NULL,
    person_lastname character varying(40) COLLATE pg_catalog."default" NOT NULL,
    person_firstname character varying(30) COLLATE pg_catalog."default" NOT NULL,
    person_middlename character varying(50) COLLATE pg_catalog."default" NOT NULL,
    person_user_id uuid NOT NULL,
    person_transport_id integer NOT NULL
) server fdelivery_personell options (table_name 'tb_delivery_person');

create server fclient foreign data wrapper postgres_fdw options (host 'localhost', dbname 'clients');

create user mapping for current_user server fclient options (user 'postgres', password '1');

create foreign table tb_fclient
(
	client_id integer NOT NULL,
    client_lastname character varying(40) COLLATE pg_catalog."default" NOT NULL,
    client_firstname character varying(30) COLLATE pg_catalog."default" NOT NULL,
    client_middlename character varying(50) COLLATE pg_catalog."default" NOT NULL,
    client_user_id uuid NOT NULL
) server fclient options (table_name 'tb_client');

create server fwarehouse foreign data wrapper postgres_fdw options (host 'localhost', dbname 'warehouses');

create user mapping for current_user server fwarehouse options (user 'postgres', password '1');

create foreign table tb_fwarehouse
(
	warehouse_id integer NOT NULL,
    warehouse_name character varying(150) COLLATE pg_catalog."default" NOT NULL,
    warehouse_address character varying(350) COLLATE pg_catalog."default" NOT NULL,
    warehouse_point geography(Point,4326) NOT NULL,
    warehouse_type_id smallint NOT NULL
) server fwarehouse options (table_name 'tb_warehouse');

-- Delivery Person
create or replace function fkey_deliveryperson_func() returns trigger
as $$
declare
	p_id int;
begin
	select person_id from tb_fdelivery_person into p_id where person_id = new.package_deliveryperson_id;
	if p_id = null then
		raise exception 'Person not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_deliveryperson before insert or update or delete
on tb_package for each row execute function fkey_deliveryperson_func();

-- Both sender and receiver
create or replace function fkey_sender_receiver_func() returns trigger
as $$
declare
	s_id int;
	r_id int;
begin
	select client_id from tb_fclient into s_id where client_id = new.package_sender_id;
	select client_id from tb_fclient into r_id where client_id = new.package_receiver_id;
	
	if s_id = null then
		raise exception 'Person not found';
	end if;
	
	if r_id = null then
		raise exception 'Person not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_sender_receiver before insert or update or delete
on tb_package for each row execute function fkey_sender_receiver_func();

-- Warehouses
create or replace function fkey_warehouse_func() returns trigger
as $$
declare
	w_id int;
begin
	select warehouse_id from tb_fwarehouse into w_id where warehouse_id = new.package_warehouse_id;
	if w_id = null then
		raise exception 'Warehouse not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_warehouse before insert or update or delete
on tb_package for each row execute function fkey_warehouse_func();