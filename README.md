# sql_data_warehouse_project
Building a modern data warehouse with SQL Server, including ETL processes, data modeling and analytics.

1. Creating brand new database "DataWarehouse".
2. Creating schemas for bronze, silver, gold.

# Bronze Layer
Building the original data

1.Creating tables for respective crm and erp data sets.
2.using bulk insert for filling data from source files onto earlier created tables.

## Checking tips after each bulk insert -
-  is data accurately inserted ?
-  number of columns match ?
-  column to column sync check ?
-  total row count match ?
-  last cell at 'end' should be blank in source file(csv insert with spaces might omit last record)
-  depending on datasets, int or nvarchar in bronze is more suitable than date, date conversion can be done is silver

## Adding error handling, load metrics etc
-  Adding try and catch logic with catch statements like error_message, error_number etc.
-  Adding time variables like start and end to measere loading time for tables and entire batch load time
  
