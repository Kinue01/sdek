create extension postgres_fdw;

create table if not exists tb_item
(
	item_id serial primary key,
	item_name varchar(150) not null,
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

insert into tb_item (item_name, item_description, item_length, item_width, item_heigth, item_weight)
values ('Отвертка с насадками/битами Smartbuy SBT-SCBS-31P1', 'Инструменты', 6, 10, 5, 1.25),
('23.8" Монитор Xiaomi A24i черный', 'Мониторы', 15, 10, 5, 1.5),
('Оперативная память Patriot Viper 4 Steel', 'Оперативная память', 2, 1, 1, 0.875);

insert into tb_package_items
values ('8a1b056a-8c11-4929-9e47-11b13787e68a', 1, 1),
('670ebb6d-8757-4a48-8a00-29d332a24552', 1, 1),
('ba888586-8610-45d5-b6c0-c51c17e7db04', 1, 2);

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

create or replace trigger fkey_package before insert
on tb_package_items for each row execute function fkey_package_func();

drop trigger fkey_package on tb_package_items;