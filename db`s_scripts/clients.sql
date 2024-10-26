create database clients;

create extension postgres_fdw;

create table if not exists tb_client
(
	client_id serial primary key,
	client_lastname varchar(40) not null,
	client_firstname varchar(30) not null,
	client_middlename varchar(50) not null,
	client_user_id uuid not null
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

create or replace function fkey_user_func() returns trigger
as $$
declare
	u_id uuid;
begin
	select user_id from tb_fuser into u_id where user_id = new.client_user_id;
	if u_id = null then
		raise exception 'User not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_user before insert or update or delete
on tb_client for each row execute function fkey_user_func();