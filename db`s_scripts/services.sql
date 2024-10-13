create database services;

create table if not exists tb_service
(
	service_id smallserial primary key,
	service_name varchar(50) not null,
	service_pay decimal(6, 1) not null
);

create table if not exists tb_package_services
(
	package_id uuid not null,
	service_id smallint not null,
	service_count int not null,
	foreign key (service_id) references tb_service (service_id),
	primary key (package_id, service_id)
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
on tb_package_services for each row execute function fkey_package_func();