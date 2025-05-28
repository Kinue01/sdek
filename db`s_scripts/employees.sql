create extension postgres_fdw;
create extension pgcrypto;

create table if not exists tb_position
(
	position_id smallserial primary key,
	position_name varchar(20) not null,
	position_base_pay int not null
);

create table if not exists tb_employee
(
	employee_id uuid primary key default gen_random_uuid(),
	employee_lastname varchar(40) not null,
	employee_firstname varchar(30) not null,
	employee_middlename varchar(50) not null,
	employee_position_id smallint not null,
	employee_user_id uuid not null,
	foreign key (employee_position_id) references tb_position (position_id)
);

create server fuser foreign data wrapper postgres_fdw options (host 'localhost', dbname 'users');

create user mapping for current_user server fuser options (user 'postgres', password '1');

create foreign table tb_fuser
(
	user_id uuid NOT NULL,
    user_login character varying(30) COLLATE pg_catalog."default" NOT NULL,
    user_password text COLLATE pg_catalog."default" NOT NULL,
    user_email character varying(320) COLLATE pg_catalog."default",
    user_phone character varying(12) COLLATE pg_catalog."default" NOT NULL,
    user_access_token text COLLATE pg_catalog."default",
    user_role_id smallint NOT NULL
) server fuser options (table_name 'tb_user');

create foreign table tb_fuser_role
(
	role_id smallint NOT NULL,
    role_name character varying(30) COLLATE pg_catalog."default" NOT NULL
) server fuser options (table_name 'tb_role');

insert into tb_position (position_name, position_base_pay)
values ('Менеджер', 120000), ('Директор', 200000), ('Администратор', 100000);

insert into tb_employee
values 
('5cefb4a2-64da-4c84-8256-3a4272683f8a', 'Казакова', 'Виктория', 'Ярославовна', 3, '23beecfe-b120-483b-b1ee-ca4208e55bcc'),
('213f909e-372c-449c-a8e8-0de57a92ba4c', 'Васильева', 'Алия', 'Никитична', 1, '3f35b2f9-8222-456f-80bd-3504b6b55e36'),
('7f5d7d19-cc40-4cd9-b3aa-4bda58cbf623', 'Николаева', 'Ярослава', 'Александровна', 2, '80b69761-5dbc-4d85-b663-55de908572c3');

create or replace function fkey_user_func() returns trigger
as $$
declare
	u_id uuid;
begin
	select user_id from tb_fuser into u_id where user_id = new.employee_user_id;
	if u_id = null then
		raise exception 'User not found';
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger fkey_user before insert
on tb_employee for each row execute function fkey_user_func();