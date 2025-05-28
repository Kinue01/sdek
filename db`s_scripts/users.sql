create extension pgcrypto;

create table if not exists tb_role
(
	role_id smallserial primary key,
	role_name varchar(30) not null
);

create table if not exists tb_user
(
	user_id uuid primary key default gen_random_uuid(),
	user_login varchar(30) not null,
	user_password text not null,
	user_email varchar(320),
	user_phone varchar(12) not null,
	user_access_token text,
	user_role_id smallint not null,
	foreign key (user_role_id) references tb_role (role_id)
);

insert into tb_role (role_name) 
values ('Клиент'), ('Сотрудник');

insert into tb_user
values 
('e49b998b-30f5-45a9-a985-40ed48fee708', 'zemindaris', '66m5rJ3v', 'bejenam-ape4@mail.com', '+79025488744', '', 1),
('9318474d-5f15-4f55-98b4-5e9188d3593b', 'chimerical', 'Fxdpahdt', 'woja-botusu19@hotmail.com', '+79609307336', '', 1),
('21e480b9-7eb3-4e7f-9084-052d6c19df92', 'modellings', 'NvBRKeEH', 'kaviz-ozajo63@yahoo.com', '+79162912969', '', 1),
('23beecfe-b120-483b-b1ee-ca4208e55bcc', 'pitchstone', 'g3Mk43jP', 'wegu_posuwa17@aol.com', '+79857319418', '', 2),
('3f35b2f9-8222-456f-80bd-3504b6b55e36', 'trappiness', 'ZF75v5XE', 'zanon_udiso37@aol.com', '+79581954692', '', 2),
('80b69761-5dbc-4d85-b663-55de908572c3', 'varnishers', 'wAmg22H4', 'zeyo_rabega83@aol.com', '+79478328775', '', 2),
('42d04d37-8870-4846-9843-a8c01514deb1', 'delivery1', 'wAmg22J4', 'delivery1_rabega83@mail.com', '+79478328775', '', 2),
('ce72d9e7-b764-4285-a2fb-6758501a15aa', 'delivery2', 'wAmg22A4', 'delivery2_rabega83@mail.com', '+79478328776', '', 2),
('a49f21cc-f64c-4fe0-9255-671127422302', 'delivery3', 'wAmg22M4', 'delivery3_rabega83@mail.com', '+79478328777', '', 2);