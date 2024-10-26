create database delivery_personell;

create extension postgres_fdw;

create table tb_delivery_person
(
	person_id serial primary key,
	person_lastname varchar(40) not null,
	person_firstname varchar(30) not null,
	person_middlename varchar(50) not null,
	person_user_id uuid not null,
	person_transport_id int not null
);

create server fuser foreign data wrapper postgres_fdw options (host 'localhost', dbname 'users');

create user mapping for current_user server fuser options (user 'postgres', password '1');

create foreign table tb_fuser
(
	user_id uuid NOT NULL,
    user_login character varying(30) COLLATE pg_catalog."default" NOT NULL,
    user_password text COLLATE pg_catalog."default" NOT NULL,
    user_email character varying(320) COLLATE pg_catalog."default",
    user_phone character varying(11) COLLATE pg_catalog."default" NOT NULL,
    user_access_token text COLLATE pg_catalog."default",
    user_role_id smallint NOT NULL
) server fuser options (table_name 'tb_user');

create server ftransport foreign data wrapper postgres_fdw options (host 'localhost', dbname 'transport');

create user mapping for current_user server ftransport options (user 'postgres', password '1');

create foreign table tb_ftransport
(
	transport_id integer NOT NULL,
    transport_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    transport_reg_number character varying(6) COLLATE pg_catalog."default" NOT NULL,
    transport_type_id smallint NOT NULL,
    transport_status_id smallint NOT NULL
) server ftransport options (table_name 'tb_transport');

-- User
create or replace function fkey_user_func() returns trigger
as $$
declare
	u_id uuid;
begin
	select user_id from tb_fuser into u_id where user_id = new.person_user_id;
	if u_id = null then
		raise exception 'User not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_user before insert or update or delete
on tb_delivery_person for each row execute function fkey_user_func();

-- Transport
create or replace function fkey_transport_func() returns trigger
as $$
declare
	t_id int;
begin
	select transport_id from tb_ftransport into t_id where transport_id = new.person_transport_id;
	if t_id = null then
		raise exception 'Transport not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_transport before insert or update or delete
on tb_delivery_person for each row execute function fkey_transport_func();