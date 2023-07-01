create table userdbs
(
	aadhar_id number,
	name varchar2(200),
	age number,
	gender char(1),
	door_no number,
	locality varchar2(200),
	city varchar2(200),
	state varchar2(200),
	pin_code number(6),
	primary key(aadhar_id)
);



create table login_credentials
(
	user_name varchar2(20),
	password varchar2(20),
	aadhar_id number,
	primary key(user_name),
	foreign key(aadhar_id) references userdbs(aadhar_id)
);



create table manager
(
	aadhar_id number,
	salary number,
	rating number,
	primary key(aadhar_id),
	foreign key(aadhar_id) references userdbs(aadhar_id)
);



create table customer
(
	aadhar_id number,
	rating number,
	primary key(aadhar_id),
	foreign key(aadhar_id) references userdbs(aadhar_id)
);



create table admin_dba
(
	aadhar_id number,
	primary key(aadhar_id),
	foreign key(aadhar_id) references userdbs(aadhar_id)
);



create table user_phone_no
(
	phone_no number(12),
	aadhar_id number,
	primary key(phone_no, aadhar_id),
	foreign key(aadhar_id) references userdbs(aadhar_id)
);



create table owner
(
	aadhar_id number,
	property_id number,
	expected_rent decimal,
	primary key(aadhar_id, property_id),
	foreign key(aadhar_id) references customer(aadhar_id),
	foreign key(property_id) references property(property_id)
);


create table tenant
(
	aadhar_id number,
	property_id number,
	maritial_status varchar2(10),
	primary key(aadhar_id, property_id),
	foreign key(aadhar_id) references customer(aadhar_id),
	foreign key(property_id) references property(property_id)
);



create table property
(
	property_id number,
	manager_aadhar_id number,
	owner_aadhar_id number,
	available_from date,
	available_till date,
	rent_per_month decimal,
	annual_hike decimal,
	total_area decimal,
	plinth_area decimal,
	no_of_floors number,
	construction_year number(4),
	address varchar2(500),
	primary key(property_id),
	foreign key(owner_aadhar_id) references owner(aadhar_id),
	foreign key(manager_aadhar_id) references manager(aadhar_id)
);



create table commercial
(
	property_id number,
	prebuilt_infra varchar2(200),
	type varchar2(200),
	primary key(property_id),
	foreign key(property_id) references property(property_id)
);



create table residential
(
	property_id number,
	no_of_bedrooms number, 
	type varchar2(20),
	primary key(property_id),
	foreign key(property_id) references property(property_id)
);



create table currently_rented
(
	property_id number,
	aadhar_id number,
	start_date date,
	end_date date,
	agency_comm decimal,
	primary key(property_id, aadhar_id),
	foreign key(property_id) references property(property_id),
	foreign key(aadhar_id) references tenant(aadhar_id)
);



create table previously_rented
(
	property_id number,
	aadhar_id number,
	start_date date,
	end_date date,
	rent_per_month number,
	annual_hike decimal,
	agency_comm decimal,
	primary key(property_id, aadhar_id, start_date),
	foreign key(property_id) references property(property_id),
	foreign key(aadhar_id) references tenant(aadhar_id)
);



set serveroutput on;



create or replace procedure InsertPropertyRecord
(
	p_id in property.property_id%type,
	m_a_id in property.manager_aadhar_id%type,
	o_a_id in property.owner_aadhar_id%type,
	from_date in property.available_from%type,
	till_date in property.available_till%type,
	rent in property.rent_per_month%type,
	hike in property.annual_hike%type,
	tot_area in property.total_area%type,
	p_area in property.plinth_area%type,
	floors in property.no_of_floors%type,
	c_year in property.construction_year%type,
	address in property.address%type
)
as
    v_id owner.aadhar_id%type;
    v_count number;
begin
    v_id := o_a_id;
    select count(*) into v_count from owner where v_id = aadhar_id;
    if v_count = 0 then
		insert into owner values (o_a_id, p_id, rent);
    end if;
	insert into property values (p_id, m_a_id, o_a_id, from_date, till_date, rent, hike, tot_area, p_area, floors, c_year, address);
end;
/



create or replace procedure AuxilaryGetPropertyRecords (id in property.property_id%type) as
	v_res residential%rowtype;
	v_com commercial%rowtype;
	cursor res_cursor is select * from residential where id = property_id;
	cursor com_cursor is select * from commercial where id = property_id;
begin
	open res_cursor;
	open com_cursor;
	loop
		fetch res_cursor into v_res;
		exit when res_cursor%notfound;
		DBMS_OUTPUT.PUT_LINE(RPAD('CATEGORY',20)||': '||'RESIDENTIAL');
		DBMS_OUTPUT.PUT_LINE(RPAD('TYPE',20)||': '||v_res.type);
		DBMS_OUTPUT.PUT_LINE(RPAD('NO OF BEDROOMS',20)||': '||v_res.no_of_bedrooms);
	end loop;
	loop
		fetch com_cursor into v_com;
		exit when com_cursor%notfound;
		DBMS_OUTPUT.PUT_LINE(RPAD('CATEGORY',20)||': '||'COMMERCIAL');
		DBMS_OUTPUT.PUT_LINE(RPAD('TYPE',20)||': '||v_com.type);
		DBMS_OUTPUT.PUT_LINE(RPAD('PREBUILT INFRA',20)||': '||v_com.prebuilt_infra);
	end loop;
	close res_cursor;
	close com_cursor;
end;
/



create or replace procedure GetPropertyRecords (id in owner.aadhar_id%type) as
	v_prop property%rowtype;
	cursor prop_cursor is select * into v_prop from property where owner_aadhar_id = id;
begin
	DBMS_OUTPUT.PUT_LINE(LPAD('-',40,'-'));
	DBMS_OUTPUT.PUT_LINE('PROPERTY INFORMATION');
    DBMS_OUTPUT.PUT_LINE(LPAD('-' ,40, '-'));
	for l_idx in prop_cursor
	loop
		DBMS_OUTPUT.PUT_LINE(RPAD('PROPERTY ID',20)||': '||l_idx.property_id);
		DBMS_OUTPUT.PUT_LINE(RPAD('MANAGER ID',20)||': '||l_idx.manager_aadhar_id);
		DBMS_OUTPUT.PUT_LINE(RPAD('AVAILABLE FROM',20)||': '||l_idx.available_from);
		DBMS_OUTPUT.PUT_LINE(RPAD('AVAILABLE TILL',20)||': '||l_idx.available_till);
		DBMS_OUTPUT.PUT_LINE(RPAD('RENT PER MONTH',20)||': '||l_idx.rent_per_month);
		DBMS_OUTPUT.PUT_LINE(RPAD('ANNUAL HIKE',20)||': '||l_idx.annual_hike);
		DBMS_OUTPUT.PUT_LINE(RPAD('TOTAL AREA',20)||': '||l_idx.total_area);
		DBMS_OUTPUT.PUT_LINE(RPAD('PLINTH AREA',20)||': '||l_idx.plinth_area);
		DBMS_OUTPUT.PUT_LINE(RPAD('NUMBER OF FLOORS',20)||': '||l_idx.no_of_floors);
		DBMS_OUTPUT.PUT_LINE(RPAD('CONSTRUCTION YEAR',20)||': '||l_idx.construction_year);
		AuxilaryGetPropertyRecords(l_idx.property_id);
		DBMS_OUTPUT.PUT_LINE(RPAD('ADDRESS',20)||': '||l_idx.address);
		DBMS_OUTPUT.PUT_LINE(LPAD('-',40,'-'));
	end loop;
end;
/



create or replace procedure GetTenantDetails (id in property.property_id%type) as
	v_user userdbs%rowtype;
	v_phone user_phone_no.phone_no%type;
	v_mstatus tenant.maritial_status%type;
	v_rating customer.rating%type;
	cursor ten_cursor is select * from userdbs where aadhar_id in (select aadhar_id from currently_rented where property_id = id);
	cursor phone_cursor(v_id user_phone_no.aadhar_id%type) is select u_pno.phone_no from user_phone_no u_pno where u_pno.aadhar_id = v_id;
begin
	DBMS_OUTPUT.PUT_LINE(LPAD('-',40,'-'));
	DBMS_OUTPUT.PUT_LINE('TENANT INFORMATION');
	DBMS_OUTPUT.PUT_LINE(LPAD('-' ,40, '-'));
	open ten_cursor;
	loop
		fetch ten_cursor into v_user;
		exit when ten_cursor%notfound;
		DBMS_OUTPUT.PUT_LINE(RPAD('AADHAR ID',20)||': '||v_user.aadhar_id);
		DBMS_OUTPUT.PUT_LINE(RPAD('NAME',20)||': '||v_user.name);
		DBMS_OUTPUT.PUT_LINE(RPAD('AGE',20)||': '||v_user.age);
		DBMS_OUTPUT.PUT_LINE(RPAD('GENDER',20)||': '||v_user.gender);
		select t.maritial_status into v_mstatus from tenant t where t.aadhar_id = v_user.aadhar_id;
		DBMS_OUTPUT.PUT_LINE(RPAD('MARITIAL STATUS',20)||': '||v_mstatus);
		for l_idx in phone_cursor(v_user.aadhar_id)
		loop
			DBMS_OUTPUT.PUT_LINE(RPAD('PHONE NO',20)||': '||v_phone);
		end loop;
		DBMS_OUTPUT.PUT_LINE(RPAD('DOOR NO',20)||': '||v_user.door_no);
		DBMS_OUTPUT.PUT_LINE(RPAD('LOCALITY',20)||': '||v_user.locality);
		DBMS_OUTPUT.PUT_LINE(RPAD('CITY',20)||': '||v_user.city);
		DBMS_OUTPUT.PUT_LINE(RPAD('STATE',20)||': '||v_user.state);
		DBMS_OUTPUT.PUT_LINE(RPAD('PIN CODE',20)||': '||v_user.pin_code);
		select c.rating into v_rating from customer c where c.aadhar_id = v_user.aadhar_id;
		DBMS_OUTPUT.PUT_LINE(RPAD('RATING',20)||': '||v_user.aadhar_id);
	end loop;
	close ten_cursor;
end;
/



create or replace procedure CreateNewUser
(
	id in userdbs.aadhar_id%type,
	name in userdbs.name%type,
	age in userdbs.age%type,
	gender in userdbs.gender%type,
	phone in user_phone_no.phone_no%type,
	door in userdbs.door_no%type,
	locality in userdbs.locality%type,
	city in userdbs.city%type,
	state in userdbs.state%type,
	pin in userdbs.pin_code%type,
	type in varchar2,
	u_name in login_credentials.user_name%type,
	pass in login_credentials.password%type
)
as
begin
	insert into userdbs values (id, name, age, gender, door, locality, city, state, pin);
	insert into user_phone_no values (phone, id);
	insert into login_credentials values (u_name, pass, id);
	if type = 'CUSTOMER' then
		insert into customer values (id, null);
	elsif type = 'MANAGER' then
		insert into manager values (id, null, null);
	elsif type = 'ADMIN' then
		insert into admin_dba values (id);
	end if;
end;
/



create or replace procedure SearchPropertyForRent (area in property.address%type) as
	v_prop property%rowtype;
	cursor prop_cursor is select * from property p where p.property_id not in 
	(select cr.property_id from currently_rented cr where cr.property_id in (select property_id from property where address like '%' || area || '%'));
begin
	DBMS_OUTPUT.PUT_LINE(LPAD('-',40,'-'));
	DBMS_OUTPUT.PUT_LINE('PROPERTY INFORMATION');
	DBMS_OUTPUT.PUT_LINE(LPAD('-' ,40, '-'));
	for l_idx in prop_cursor
	loop
		DBMS_OUTPUT.PUT_LINE(RPAD('PROPERTY ID',20)||': '||l_idx.property_id);
		DBMS_OUTPUT.PUT_LINE(RPAD('MANAGER ID',20)||': '||l_idx.manager_aadhar_id);
		DBMS_OUTPUT.PUT_LINE(RPAD('AVAILABLE FROM',20)||': '||l_idx.available_from);
		DBMS_OUTPUT.PUT_LINE(RPAD('AVAILABLE TILL',20)||': '||l_idx.available_till);
		DBMS_OUTPUT.PUT_LINE(RPAD('RENT PER MONTH',20)||': '||l_idx.rent_per_month);
		DBMS_OUTPUT.PUT_LINE(RPAD('ANNUAL HIKE',20)||': '||l_idx.annual_hike);
		DBMS_OUTPUT.PUT_LINE(RPAD('TOTAL AREA',20)||': '||l_idx.total_area);
		DBMS_OUTPUT.PUT_LINE(RPAD('PLINTH AREA',20)||': '||l_idx.plinth_area);
		DBMS_OUTPUT.PUT_LINE(RPAD('NUMBER OF FLOORS',20)||': '||l_idx.no_of_floors);
		DBMS_OUTPUT.PUT_LINE(RPAD('CONSTRUCTION YEAR',20)||': '||l_idx.construction_year);
		AuxilaryGetPropertyRecords(l_idx.property_id);
		DBMS_OUTPUT.PUT_LINE(RPAD('ADDRESS',20)||': '||l_idx.address);
		DBMS_OUTPUT.PUT_LINE(LPAD('-',40,'-'));
	end loop;
end;
/



create or replace procedure GetRentHistory (id in property.property_id%type) as
	v_rented previously_rented%rowtype;
	cursor rented_cursor is select * from previously_rented where previously_rented.property_id = id;
begin
	DBMS_OUTPUT.PUT_LINE(LPAD('-',40,'-'));
	DBMS_OUTPUT.PUT_LINE('PROPERTY INFORMATION');
	DBMS_OUTPUT.PUT_LINE(LPAD('-' ,40, '-'));
	for l_idx in rented_cursor
	loop
		DBMS_OUTPUT.PUT_LINE(RPAD('PROPERTY ID',20)||': '||l_idx.property_id);
		DBMS_OUTPUT.PUT_LINE(RPAD('TENANT ID',20)||': '||l_idx.aadhar_id);
		DBMS_OUTPUT.PUT_LINE(RPAD('RENTED FROM',20)||': '||l_idx.start_date);
		DBMS_OUTPUT.PUT_LINE(RPAD('RENTED TILL',20)||': '||l_idx.end_date);
		DBMS_OUTPUT.PUT_LINE(RPAD('RENT PER MONTH',20)||': '||l_idx.rent_per_month);
		DBMS_OUTPUT.PUT_LINE(RPAD('ANNUAL HIKE',20)||': '||l_idx.annual_hike);
		DBMS_OUTPUT.PUT_LINE(RPAD('AGENCY COMMISSION',20)||': '||l_idx.agency_comm);
		DBMS_OUTPUT.PUT_LINE(LPAD('-',40,'-'));
	end loop;
end;
/