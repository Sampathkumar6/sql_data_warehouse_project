# sql_data_warehouse_project

Building a modern data warehouse with SQL Server, including ETL processes, data modeling and analytics.
This repository contains the architecture, scripts, and source data for building an enterprise SQL Data Warehouse.

1. Creating brand new database "DataWarehouse".
2. Creating schemas for bronze, silver, gold.

## Directory Structure
* **datasets/** - Raw source data (CSV/Excel files).
* **design/** - Data models, architecture diagrams, and schema blueprints.
* **scripts/** - SQL scripts for ETL pipeline, DDL tables, and stored procedures.

----------------------------------------------------------------------------------------------

# Bronze Layer
1.  Interview source system experts
2.  Data Ingetion
3.  Data completeness and schema checks
4.  Data documentation

## Building the original data

1.  Creating tables for respective crm and erp data sets.
2.  Using bulk insert for filling data from source files onto earlier created tables.
3.  Introducing start,end time variable to show individual and batch load metrics.
4.  Introducing error handling statements (try,catch) which provide info luike error message, number etc.
5.  Saving the entire load section to stored procedure

## Checking tips after each bulk insert -
-  is data accurately inserted ?
-  number of columns match ?
-  column to column sync check ?
-  total row count match ?
-  last cell at 'end' should be blank in source file(csv insert with spaces might omit last record)
-  depending on datasets, int or nvarchar in bronze is more suitable than date, date conversion can be done is silver

### Questionnaire
![Bronze Layer Questionnaire](images/Bronze_layer/Bronze_layer_questionaire.PNG)

## Adding error handling, load metrics etc
-  Adding try and catch logic with catch statements like error_message, error_number etc.
-  Adding time variables like start and end to measere loading time for tables and entire batch load time

## Snapshots relevant to bronze layer

![Creating tables](images/Bronze_layer/Creating_tables.PNG) ![Bronze layer stored procedure](images/Bronze_layer/Bronze_layer_stored_procedure.PNG) ![Loading data](images/Bronze_layer/Bronze_layer_loading_data.PNG)

## trial for smaller size pics

<!-- <table>
    <tr>
        <td>
            <p align="center"><b>Creating Tables</b></p>
            <img src="images/Bronze_layer/Creating_tables.PNG" width="200" alt="Creating tables">
        </td>
        <td>
            <p align="center"><b>Loading Data</b></p>
            <img src="images/Bronze_layer/Bronze_layer_loading_data.PNG" width="200" alt="Loading data">
        </td>
        <td>
            <p align="center"><b>Stored Procedure</b></p>
            <img src="images/Bronze_layer/Bronze_layer_stored_procedure.PNG" width="200" alt="Bronze layer stored procedure">
        </td>
    </tr>
</table> -->

<!-- <table border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse; border: none;">
    <tr style="border: none;">
        <td align="center" valign="top" style="border: none;">
            <b>Creating Tables</b><br>
            <img src="images/Bronze_layer/Creating_tables.PNG" width="200" alt="Creating tables">
        </td>
        <td align="center" valign="top" style="border: none;">
            <b>Loading Data</b><br>
            <img src="images/Bronze_layer/Bronze_layer_loading_data.PNG" width="200" alt="Loading data">
        </td>
        <td align="center" valign="top" style="border: none;">
            <b>Stored Procedure</b><br>
            <img src="images/Bronze_layer/Bronze_layer_stored_procedure.PNG" width="200" alt="Bronze layer stored procedure">
        </td>
    </tr>
</table> -->

--------------------

<p align="center">
  <b>Creating Tables</b> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <b>Loading Data</b> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <b>Stored Procedure</b><br>
  <img src="images/Bronze_layer/Creating_tables.PNG" width="200" alt="Creating tables" /> &nbsp; &nbsp; 
  <img src="images/Bronze_layer/Bronze_layer_loading_data.PNG" width="200" alt="Loading data" /> &nbsp; &nbsp; 
  <img src="images/Bronze_layer/Bronze_layer_stored_procedure.PNG" width="200" alt="Bronze layer stored procedure" />
</p>


----------------------------------------------------------------------------------------------

# Silver Layer

1. Transforming data from bronze layer and inserting onto silver layer

