drop table daily_activity_subcategory_attributes;
drop table daily_activity_category_attributes;
drop table attribute_datatype_enum;
drop table daily_activity_subcategory;
drop table daily_activity_category;

create table attribute_datatype_enum(
	enum_name varchar(255) primary key,
	option_key varchar(255) not null,
	option_displayed_value varchar(255) not null,
	option_data jsonb
);

create table daily_activity_category (
	id varchar(255) primary key,
	name varchar(255) not null
);
create table daily_activity_subcategory(
	id varchar(255) primary key,
	category_id varchar(255) references daily_activity_category(id) not null,
	name varchar(255) not null
);

create table daily_activity_category_attributes(
	id varchar(255) primary key,
	category_id varchar(255) references daily_activity_category(id) not null,
	name varchar(255) not null,
	datatype varchar(255),
	enum_name varchar(255) references attribute_datatype_enum(enum_name)
);
create table daily_activity_subcategory_attributes(
	id varchar(255) primary key,
	subcategory_id varchar(255) references daily_activity_subcategory(id) not null,
	name varchar(255) not null,
	datatype varchar(255),
	enum_name varchar(255) references attribute_datatype_enum(enum_name)
);

