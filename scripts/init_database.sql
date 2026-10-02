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
