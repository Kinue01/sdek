create extension postgres_fdw;

create table if not exists tb_service
(
	service_id smallserial primary key,
	service_name varchar(50) not null,
	service_pay decimal(6, 1) not null
);

create table if not exists tb_package_services
(
	package_id uuid not null,
	service_id smallint not null,
	service_count int not null,
	foreign key (service_id) references tb_service (service_id),
	primary key (package_id, service_id)
);

create server fpackage foreign data wrapper postgres_fdw options (host 'localhost', dbname 'packages');

create user mapping for current_user server fpackage options (user 'postgres', password '1');

create foreign table tb_fpackage
(
	package_uuid uuid NOT NULL,
    package_send_date date,
    package_receive_date date,
    package_weight numeric(7,3),
    package_deliveryperson_id integer NOT NULL,
    package_type_id smallint NOT NULL,
    package_status_id smallint NOT NULL,
    package_sender_id integer NOT NULL,
    package_receiver_id integer NOT NULL,
    package_warehouse_id integer NOT NULL,
    package_paytype_id smallint NOT NULL,
    package_payer_id int NOT NULL
) server fpackage options (table_name 'tb_package');

create foreign table tb_fpackage_type
(
	type_id smallint not null,
	type_name varchar(20) not null,
	type_length int not null,
	type_width int not null,
	type_height int not null
) server fpackage options (table_name 'tb_package_type');

create foreign table tb_fpackage_status
(	
	status_id smallint not null,
	status_name varchar(30) not null
) server fpackage options (table_name 'tb_package_status');

create foreign table tb_fpackage_paytype
(
	type_id smallint not null,
	type_name varchar(40) not null
) server fpackage options (table_name 'tb_package_paytype');

create foreign table tb_fdelivery_person
(
	person_id integer NOT NULL,
    person_lastname character varying(40) COLLATE pg_catalog."default" NOT NULL,
    person_firstname character varying(30) COLLATE pg_catalog."default" NOT NULL,
    person_middlename character varying(50) COLLATE pg_catalog."default" NOT NULL,
    person_user_id uuid NOT NULL,
    person_transport_id integer NOT NULL
) server fpackage options (table_name 'tb_fdelivery_person');

create foreign table tb_fclient
(
	client_id integer NOT NULL,
    client_lastname character varying(40) COLLATE pg_catalog."default" NOT NULL,
    client_firstname character varying(30) COLLATE pg_catalog."default" NOT NULL,
    client_middlename character varying(50) COLLATE pg_catalog."default" NOT NULL,
    client_user_id uuid NOT NULL
) server fpackage options (table_name 'tb_fclient');

create foreign table tb_fwarehouse
(
	warehouse_id integer NOT NULL,
    warehouse_name character varying(150) COLLATE pg_catalog."default" NOT NULL,
    warehouse_address character varying(350) COLLATE pg_catalog."default" NOT NULL,
    warehouse_type_id smallint NOT NULL
) server fpackage options (table_name 'tb_fwarehouse');

create foreign table tb_fwarehouse_type
(
	type_id smallint NOT NULL,
    type_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    type_small_quantity integer NOT NULL,
    type_med_quantity integer NOT NULL,
    type_huge_quantity integer NOT NULL
) server fpackage options (table_name 'tb_fwarehouse_type');

create foreign table tb_fitem
(
	item_id integer NOT NULL,
    item_name character varying(25) COLLATE pg_catalog."default" NOT NULL,
    item_description character varying(200) COLLATE pg_catalog."default" NOT NULL,
    item_length numeric(5,1) NOT NULL,
    item_width numeric(5,1) NOT NULL,
    item_heigth numeric(5,1) NOT NULL,
    item_weight numeric(6,1) NOT NULL
) server fpackage options (table_name 'tb_fitem');

create foreign table tb_fpackage_items
(
	package_id uuid NOT NULL,
    item_id integer NOT NULL,
    item_quantity integer NOT NULL
) server fpackage options (table_name 'tb_fpackage_items');

create foreign table tb_fuser
(
	user_id uuid NOT NULL,
    user_login character varying(30) COLLATE pg_catalog."default" NOT NULL,
    user_password text COLLATE pg_catalog."default" NOT NULL,
    user_email character varying(320) COLLATE pg_catalog."default",
    user_phone character varying(12) COLLATE pg_catalog."default" NOT NULL,
    user_access_token text COLLATE pg_catalog."default",
    user_role_id smallint NOT NULL
) server fpackage options (table_name 'tb_fuser');

create foreign table tb_fuser_role
(
	role_id smallint NOT NULL,
    role_name character varying(30) COLLATE pg_catalog."default" NOT NULL
) server fpackage options (table_name 'tb_fuser_role');

create foreign table tb_ftransport
(
	transport_id integer NOT NULL,
    transport_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    transport_reg_number character varying(8) COLLATE pg_catalog."default" NOT NULL,
    transport_type_id smallint NOT NULL,
    transport_status_id smallint NOT NULL
) server fpackage options (table_name 'tb_ftransport');

create foreign table tb_ftransport_type
(
	type_id smallint NOT NULL,
    type_name character varying(60) COLLATE pg_catalog."default" NOT NULL
) server fpackage options (table_name 'tb_ftransport_type');

create foreign table tb_ftransport_status
(
	status_id smallint NOT NULL,
    status_name character varying(20) COLLATE pg_catalog."default" NOT NULL
) server fpackage options (table_name 'tb_ftransport_status');

insert into tb_service (service_name, service_pay)
values ('Доставка до двери', 700), ('Хранение на складе', 500);

insert into tb_package_services
values ('8a1b056a-8c11-4929-9e47-11b13787e68a', 1, 1), ('8a1b056a-8c11-4929-9e47-11b13787e68a', 2, 1);

create or replace function fkey_package_func() returns trigger
as $$
declare
	p_uuid uuid;
begin
	select package_uuid from tb_fpackage into p_uuid where package_uuid = new.package_id;
	if p_uuid = null then
		raise exception 'Package not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_package before insert or update or delete
on tb_package_services for each row execute function fkey_package_func();