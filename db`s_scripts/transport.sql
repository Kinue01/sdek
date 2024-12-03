create extension postgres_fdw;

create table if not exists tb_transport_type
(
	type_id smallserial primary key,
	type_name varchar(60) not null
);

create table if not exists tb_transport_status
(
	status_id smallserial primary key,
	status_name varchar(20) not null
);

create table if not exists tb_transport
(
	transport_id serial primary key,
	transport_name varchar(50) not null,
	transport_reg_number varchar(8) not null,
	transport_type_id smallint not null,
	transport_status_id smallint not null,
	foreign key (transport_type_id) references tb_transport_type (type_id),
	foreign key (transport_status_id) references tb_transport_status (status_id)
);

insert into tb_transport_type (type_name)
values ('Средство индивидуальной мобильности'), ('Легковой автомобиль'), ('Грузовой автомобиль');

insert into tb_transport_status (status_name)
values ('Ожидает'), ('В пути'), ('На обслуживании');

insert into tb_transport (transport_name, transport_reg_number, transport_type_id, transport_status_id)
values 
('Aceline H2', 'ВС57МС82', 1, 1),
('Kia Rio 6-speed', 'О532ЕМ48', 2, 2),
('ГАЗ ГАЗель Next 4.6', 'С404РР72', 3, 3);

create server fdelivery_personell foreign data wrapper postgres_fdw options (host 'localhost', dbname 'delivery_personell');

create user mapping for current_user server fdelivery_personell options (user 'postgres', password '1');

create foreign table tb_fdelivery_person
(
	person_id integer NOT NULL,
    person_lastname character varying(40) COLLATE pg_catalog."default" NOT NULL,
    person_firstname character varying(30) COLLATE pg_catalog."default" NOT NULL,
    person_middlename character varying(50) COLLATE pg_catalog."default" NOT NULL,
    person_user_id uuid NOT NULL,
    person_transport_id integer NOT NULL
) server fdelivery_personell options (table_name 'tb_delivery_person');