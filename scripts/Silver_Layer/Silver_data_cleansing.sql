
--Check for nulls or duplicates in primary key

select
cst_id,
count(*) as cst_Count
from bronze.crm_cust_info
group by cst_id having count(*) > 1 or cst_id is null

--Checking one of the duplicate id for further analysis

Select *,
row_number() over(partition by cst_id order by cst_create_date desc) as latest_entry
from bronze.crm_cust_info
where cst_id = 29466

-- Filtering out primary_id uniques
--Transformation table

select
cst_id,
cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
from (
select *,
row_number() over(partition by cst_id order by cst_create_date desc) as latest_entry
from bronze.crm_cust_info)t where t.latest_entry = 1

--Check for unwanted spaces

select cst_firstname
from bronze.crm_cust_info
where cst_firstname != trim(cst_firstname)