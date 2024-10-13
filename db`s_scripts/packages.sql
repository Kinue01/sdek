create database packages;

drop database packages;

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
	package_deliveryperson_id serial not null,
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

-- Delivery Person
create or replace function fkey_deliveryperson_func() returns trigger
as $$
declare
	p_id int;
begin
	select person_id from delivery_personell.public.tb_delivery_person into p_id where person_id = new.package_deliveryperson_id;
	if p_id == null then
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
	select client_id from clients.public.tb_client into s_id where client_id = new.package_sender_id;
	select client_id from clients.public.tb_client into r_id where client_id = new.package_receiver_id;
	
	if s_id == null then
		raise exception 'Person not found';
	end if;
	
	if r_id == null then
		raise exception 'Person not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_sender_receiver before insert or update or delete
on tb_package for each row execute function fkey_sender_receiver_func();

-- Warehoses
create or replace function fkey_warehouse_func() returns trigger
as $$
declare
	w_id int;
begin
	select warehouse_id from warehouses.public.tb_warehouse into w_id where warehouse_id = new.package_warehouse_id;
	if w_id == null then
		raise exception 'Warehouse not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_warehouse before insert or update or delete
on tb_package for each row execute function fkey_warehouse_func();