create database delivery_personell;

create table tb_delivery_person
(
	person_id serial primary key,
	person_lastname varchar(40) not null,
	person_firstname varchar(30) not null,
	person_middlename varchar(50) not null,
	person_user_id uuid not null,
	person_transport_id int not null
);

-- User
create or replace function fkey_user_func() returns trigger
as $$
declare
	u_id uuid;
begin
	select user_id from users.public.tb_user into u_id where user_id = new.person_user_id;
	if u_id == null then
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
	select transport_id from transports.public.tb_transport into t_id where transport_id = new.person_transport_id;
	if t_id == null then
		raise exception 'Transport not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_transport before insert or update or delete
on tb_delivery_person for each row execute function fkey_transport_func();