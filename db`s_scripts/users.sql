create table if not exists tb_role
(
	role_id smallserial primary key,
	role_name varchar(30) not null
);

create table if not exists tb_user
(
	user_id uuid primary key,
	user_login varchar(30) not null,
	user_password text not null,
	user_email varchar(320),
	user_phone varchar(11) not null,
	user_access_token text,
	user_role_id smallint not null,
	foreign key (user_role_id) references tb_role (role_id)
)