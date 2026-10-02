--setting to master DB

use master

--creating new DB

create database DataWarehouse;

--setting to project DB

use DataWarehouse;

--Setting up layer schemas

create schema bronze;
create schema silver;
create schema gold;
