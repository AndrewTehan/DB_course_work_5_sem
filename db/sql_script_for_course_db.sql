CREATE or REPLACE FUNCTION AllMasters ()
	returns table (
		master_first_name varchar,
		master_last_name varchar,
		master_phone_number varchar
	)
	LANGUAGE plpgsql
as $$
begin
	return query 
		select 
			first_name,
			last_name,
			phone_number
		from
			Users
		where
			type = 'Master';
end;$$
select * from AllMasters();

CREATE or REPLACE FUNCTION AllServices ()
	returns table (
		name_service varchar,		
		service_price integer
	)
	LANGUAGE plpgsql
as $$
begin
	return query 
		select
			service_name,
			price_cents
		from
			Services;
end;$$
select * from AllServices();

CREATE or REPLACE FUNCTION AllClients ()
	returns table (
		client_first_name varchar,
		client_last_name varchar,
		client_phone_number varchar,
		client_email varchar
	)
	LANGUAGE plpgsql
as $$
begin
	return query 
		select
			first_name,
			last_name,
			phone_number,
			email
		from
			Users
		where 
			type = 'Client';
end;$$
select * from AllClients();

CREATE or REPLACE FUNCTION AllUsers ()
	returns table (
		user_first_name varchar,
		user_last_name varchar,
		user_phone_number varchar,
		user_email varchar
	)
	LANGUAGE plpgsql
as $$
begin
	return query 
		select
			first_name,
			last_name,
			phone_number,
			email
		from
			Users;
end;$$
select * from AllUsers();

CREATE or REPLACE FUNCTION AllVisits ()
	returns table (
		visit_id bigint,
		visit_client_id bigint,
		visit_master_id bigint,
		visit_state varchar,
		visit_date timestamp,
		visit_addition varchar
	)
	LANGUAGE plpgsql
as $$
begin
	return query 
		select
			id,
			client_id,
			master_id,
			state,
			date,
			addition
		from
			Visits;
end;$$
select * from AllVisits();


CREATE or REPLACE FUNCTION VisitsById ( integer )
	returns table (
		visit_id bigint,
		visit_client_id bigint,
		visit_master_id bigint,
		visit_state varchar,
		visit_date timestamp,
		visit_addition varchar
	)
	LANGUAGE plpgsql
as $$
begin
	return query 
		select
			id,
			client_id,
			master_id,
			state,
			date,
			addition
		from
			Visits
		where
			id=$1;
end;$$
select * from VisitsById(20);

CREATE or REPLACE FUNCTION VisitMasterFullName (integer)
	returns table (
		master_first_name varchar,
		master_last_name varchar
	)
	LANGUAGE plpgsql
as $$
begin
	return query 
		select
			first_name,
			last_name
		from
			Users
		where
			type='Master'
		and
			id=$1;
end;$$
select * from VisitMasterFullName(3);

CREATE or REPLACE PROCEDURE DeleteUser(integer)
LANGUAGE SQL
AS $$
	DELETE FROM 
		Users 
	WHERE 
		id = $1;
$$;
select * from Users;
call DeleteUser(3);

CREATE or REPLACE PROCEDURE UpdateUser("a" character varying, "b" character varying, "c" character varying, "d" character varying, e integer)
LANGUAGE SQL
AS $$
	UPDATE 
		Users 
	SET 
		first_name = "a",
		last_name = "b",
		email = "c",
		phone_number = "d"
	WHERE 
		id = $5;
$$;
select * from Users;
call UpdateUser('Andrew', 'Tehanov', 'andrewtehanov@gmail.com', '+375447756860', 2);

CREATE or REPLACE PROCEDURE UpdateVisit("a" timestamp without time zone, "b" character varying, c integer)
LANGUAGE SQL
AS $$
	UPDATE 
		Visits 
	SET 
		date = "a",
		addition = "b"
	WHERE 
		id = $3;
$$;
select * from Visits;
call UpdateVisit('2021-12-31T19:29', 'something!', 20);

CREATE or REPLACE PROCEDURE DeleteVisit ( integer )
LANGUAGE SQL
AS $$
	DELETE FROM 
		service_visits 
	WHERE 
		id = $1;
	DELETE FROM 
		Visits 
	WHERE 
		id = $1;
$$;
select * from Visits;
select * from service_visits;
call DeleteVisit(20);















