create database items;

create extension postgres_fdw;

create table if not exists tb_item
(
	item_id serial primary key,
	item_name varchar(25) not null,
	item_description varchar(200) not null,
	item_length decimal(5, 1) not null,
	item_width decimal(5, 1) not null,
	item_heigth decimal(5, 1) not null,
	item_weight decimal(6, 1) not null
);

create table if not exists tb_package_items
(
	package_id uuid not null,
	item_id int not null,
	item_quantity int not null,
	foreign key (item_id) references tb_item (item_id)
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
    package_payer_id smallint NOT NULL
) server fpackage options (table_name 'tb_package');

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
on tb_package_items for each row execute function fkey_package_func();