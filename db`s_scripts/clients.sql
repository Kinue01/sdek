create database clients;

create table if not exists tb_client
(
	client_id serial primary key,
	client_lastname varchar(40) not null,
	client_firstname varchar(30) not null,
	client_middlename varchar(50) not null,
	client_user_id uuid not null
);

create or replace function fkey_user_func() returns trigger
as $$
declare
	u_id uuid;
begin
	select user_id from users.public.tb_user into u_id where user_id = new.client_user_id;
	if u_id == null then
		raise exception 'User not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_user before insert or update or delete
on tb_client for each row execute function fkey_user_func();