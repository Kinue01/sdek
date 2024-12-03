create table if not exists tb_warehouse_type
(
	type_id smallserial primary key,
	type_name varchar(50) not null,
	type_small_quantity int not null,
	type_med_quantity int not null,
	type_huge_quantity int not null
);

create table if not exists tb_warehouse
(
	warehouse_id serial primary key,
	warehouse_name varchar(150) not null,
	warehouse_address varchar(350) not null,
	warehouse_type_id smallint not null,
	foreign key (warehouse_type_id) references tb_warehouse_type (type_id)
);

insert into tb_warehouse_type (type_name, type_small_quantity, type_med_quantity, type_huge_quantity)
values 
('Пункт выдачи', 20, 5, 2),
('Малый склад', 40, 10, 5),
('Средний склад', 70, 20, 10),
('Большой склад', 150, 60, 30);

insert into tb_warehouse (warehouse_name, warehouse_address, warehouse_type_id)
values
('Пункт выдачи 1', 'Старорусская ул., 16', 1),
('Пункт выдачи 2', 'Набережная реки Фонтанки, 99', 1),
('Малый склад 1', 'Боровая ул., 39', 2),
('Малый склад 2', 'Старорусская ул., 71', 2),
('Средний склад 1', 'Лиговский пр., 87', 3),
('Средний склад 2', 'ул. Печатника Григорьева, д.98', 3),
('Большой склад 1', 'Новгородская ул., 19', 4),
('Большой склад 2', 'Миргородская ул., 7', 4);