create table if not exists tb_client
(
	client_id serial primary key,
	client_lastname varchar(40) not null,
	client_firstname varchar(30) not null,
	client_middlename varchar(50) not null,
	client_user_id uuid not null
)