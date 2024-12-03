create extension postgres_fdw;

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
	type_id smallserial primary key,
	type_name varchar(40) not null
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
	package_payer_id int not null,
	foreign key (package_type_id) references tb_package_type (type_id),
	foreign key (package_status_id) references tb_package_status (status_id),
	foreign key (package_paytype_id) references tb_package_paytype (type_id)
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
    warehouse_type_id smallint NOT NULL
) server fwarehouse options (table_name 'tb_warehouse');

create foreign table tb_fwarehouse_type
(
	type_id smallint NOT NULL,
    type_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    type_small_quantity integer NOT NULL,
    type_med_quantity integer NOT NULL,
    type_huge_quantity integer NOT NULL
) server fwarehouse options (table_name 'tb_warehouse_type');

create server fitems foreign data wrapper postgres_fdw options (host 'localhost', dbname 'items');

create user mapping for current_user server fitems options (user 'postgres', password '1');

create foreign table tb_fitem
(
	item_id integer NOT NULL,
    item_name character varying(150) COLLATE pg_catalog."default" NOT NULL,
    item_description character varying(200) COLLATE pg_catalog."default" NOT NULL,
    item_length numeric(5,1) NOT NULL,
    item_width numeric(5,1) NOT NULL,
    item_heigth numeric(5,1) NOT NULL,
    item_weight numeric(6,1) NOT NULL
) server fitems options (table_name 'tb_item');

create foreign table tb_fpackage_items
(
	package_id uuid NOT NULL,
    item_id integer NOT NULL,
    item_quantity integer NOT NULL
) server fitems options (table_name 'tb_package_items');

create server fuser foreign data wrapper postgres_fdw options (host 'localhost', dbname 'users');

create user mapping for current_user server fuser options (user 'postgres', password '1');

create foreign table tb_fuser
(
	user_id uuid NOT NULL,
    user_login character varying(30) COLLATE pg_catalog."default" NOT NULL,
    user_password text COLLATE pg_catalog."default" NOT NULL,
    user_email character varying(320) COLLATE pg_catalog."default",
    user_phone character varying(12) COLLATE pg_catalog."default" NOT NULL,
    user_access_token text COLLATE pg_catalog."default",
    user_role_id smallint NOT NULL
) server fuser options (table_name 'tb_user');

create foreign table tb_fuser_role
(
	role_id smallint NOT NULL,
    role_name character varying(30) COLLATE pg_catalog."default" NOT NULL
) server fuser options (table_name 'tb_role');

create server ftransport foreign data wrapper postgres_fdw options (host 'localhost', dbname 'transport');

create user mapping for current_user server ftransport options (user 'postgres', password '1');

create foreign table tb_ftransport
(
	transport_id integer NOT NULL,
    transport_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    transport_reg_number character varying(8) COLLATE pg_catalog."default" NOT NULL,
    transport_type_id smallint NOT NULL,
    transport_status_id smallint NOT NULL
) server ftransport options (table_name 'tb_transport');

create foreign table tb_ftransport_type
(
	type_id smallint NOT NULL,
    type_name character varying(60) COLLATE pg_catalog."default" NOT NULL
) server ftransport options (table_name 'tb_transport_type');

create foreign table tb_ftransport_status
(
	status_id smallint NOT NULL,
    status_name character varying(20) COLLATE pg_catalog."default" NOT NULL
) server ftransport options (table_name 'tb_transport_status');

insert into tb_package_type (type_name, type_length, type_width, type_height)
values 
('Малая', 5, 5, 5),
('Средняя', 15, 15, 15),
('Большая', 30, 30, 30);

insert into tb_package_status (status_name)
values ('Упаковка'), ('В пути'), ('Прибыл');

insert into tb_package_paytype (type_name)
values ('Наличными'), ('Картой'), ('СБП');

insert into tb_package
values 
('8a1b056a-8c11-4929-9e47-11b13787e68a', '2023-12-05', '2024-01-12', 1.25, 1, 1, 1, 1, 2, 3, 3, 1);

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

-- Sender and receiver and payer
create or replace function fkey_sender_receiver_func() returns trigger
as $$
declare
	s_id int;
	r_id int;
	p_id int;
begin
	select client_id from tb_fclient into s_id where client_id = new.package_sender_id;
	select client_id from tb_fclient into r_id where client_id = new.package_receiver_id;
	select client_id from tb_fclient into p_id where client_id = new.package_payer_id;
	
	if s_id = null then
		raise exception 'Person not found';
	end if;
	
	if r_id = null then
		raise exception 'Person not found';
	end if;

	
	if p_id = null then
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