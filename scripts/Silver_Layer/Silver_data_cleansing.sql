------------------------------------------------------------------------------------------
--Silver layer Clean and load tables
------------------------------------------------------------------------------------------
--This script is for data cleansing / transformation.
--the below are different checks on columns to understand what is necessary for the transformation like

--trim for removing unnecessary spaces (firstname, lastname)
--data normalization / standardization (gndr, maritalstatus)
--handling missing data with default values like (unknown)
--removing duplicates for primarykey
--isnull for handling missing values
--deriving new relevant columns by splitting a large size info column using substring
------------------------------------------------------------------------------------------
--repetetive checks during clean and load for all tables
--Check for nulls or duplicates in primary key
select
cst_id,
count(*) as cst_Count
from bronze.crm_cust_info
group by cst_id having count(*) > 1 or cst_id is null

--Checking one of the duplicate id for further analysis

Select *,
row_number() over(partition by cst_id order by cst_create_date desc) as flag_last
from bronze.crm_cust_info
where cst_id = 29466

--Check for unwanted spaces

select sls_ord_num
from bronze.crm_sales_details
where sls_ord_num != trim(sls_ord_num)

--Check for nulls or negative numbers
select prd_cost from bronze.crm_prod_info where prd_cost <=0 or prd_cost is null

--Check distinct
select distinct prd_line from bronze.crm_prod_info

--there was one record not useful without any info, so removed that, **only one run**
delete from silver.crm_cust_info where cst_id = 0

--checking for orderdate,duedate invalid ones using CTE
with cleaned_data as (
select
sls_ord_num,
sls_prd_key,
sls_cust_id,
case
	when sls_order_dt = 0 or len(sls_order_dt) !=8 then null
	else cast(cast(sls_order_dt as varchar) as date)
end as sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details)select * from cleaned_data where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt
------------------------------------------------------------------------------------------
--Transformation bronze table and inserting to silver
------------------------------------------------------------------------------------------
--bronze.crm_cust_info

insert into silver.crm_cust_info (cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
select
case
	when cst_id is null then 0
	else cst_id
end cst_id,
cst_key,
trim(cst_firstname) cst_firstname,
trim(cst_lastname) cst_lastname,
case
	when upper(trim(cst_marital_status)) = 'S' then 'Single'
	when upper(trim(cst_marital_status)) = 'M' then 'Married'
	else 'Unknown'
end cst_marital_status,
case
	when upper(trim(cst_gndr)) = 'F' then 'Female'
	when upper(trim(cst_gndr)) = 'M' then 'Male'
	else 'Unknown'
end cst_gndr,
cst_create_date
from (
select *,
row_number() over(partition by cst_id order by cst_create_date desc) as flag_last
from bronze.crm_cust_info)t where t.flag_last = 1

--crm_prod_info
insert into silver.crm_prod_info (prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
select
prd_id,
replace(substring(trim(prd_key),1,5),'-','_') as cat_id,
substring(trim(prd_key),7,len(trim(prd_key))) as prd_key,
prd_nm,
isnull(prd_cost,0) as prd_cost,
case
	when upper(trim(prd_line)) = 'M' then 'Mat'
	when upper(trim(prd_line)) = 'R' then 'sock'
	when upper(trim(prd_line)) = 'S' then 'saddle'
	when upper(trim(prd_line)) = 'T' then 'toner'
	else 'Unknown'
end as prd_line,
prd_start_dt,
case
	when prd_end_dt < prd_start_dt then DATEADD(day, 365, prd_start_dt)
	when prd_end_dt is null then DATEADD(day, 365, prd_start_dt)
	else prd_end_dt
end as prd_end_dt
from bronze.crm_prod_info

--updating ddl to accomodate cat_id **only once**
if object_id ('silver.crm_prod_info', 'U') is not null
	drop table silver.crm_prod_info

create table silver.crm_prod_info(
	prd_id int,
	cat_id nvarchar(50),
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date
);

--crm_sales_details
select
sls_ord_num,
sls_prd_key,
sls_cust_id,
case
	when sls_order_dt = 0 or len(sls_order_dt) !=8 then null
	else cast(cast(sls_order_dt as varchar) as date)
end as sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
------------------------------------------------------------------------------------------
--final check
select * from silver.crm_cust_info
select * from silver.crm_prod_info

------------------------------------------------------------------------------------------
