create database items;

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

create or replace function fkey_package_func() returns trigger
as $$
declare
	p_uuid uuid;
begin
	select package_uuid from packages.public.tb_package into p_uuid where package_uuid = new.package_id;
	if p_uuid == null then
		raise exception 'Package not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_package before insert or update or delete
on tb_package_items for each row execute function fkey_package_func();