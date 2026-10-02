/*
----------------
Script note
----------------

1. First checking system DB list if out project name is oinciding with existing ones.
2. Creating new database.
3. Creating new schemas for layers

*/

--checking for existing DB with our project DB name

go

if exists (select 1 from sys.databases where name = '')
begin
	alter database DataWarehouse set single_user with rollback immediate;
	drop database DataWarehouse;
end
go


--setting to master DB

use master

--creating new DB

create database DataWarehouse;

--setting to project DB

use DataWarehouse;

--Setting up layer schemas

go
create schema bronze;
go
create schema silver;
go
create schema gold;
