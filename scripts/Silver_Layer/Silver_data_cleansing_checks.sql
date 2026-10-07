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

--values must not be null, negative, or zero **in case nothing all is fine else rework on transformation

select distinct
sls_sales,
sls_quantity,
sls_price
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales,sls_quantity,sls_price

------------------------------------------------------------------------------------------
--final check
select * from silver.crm_cust_info
select * from silver.crm_prod_info
select * from silver.crm_sales_details
select * from silver.erp_cust_az12
select * from silver.erp_loc_a101
select * from silver.erp_px_cat_g1v2
------------------------------------------------------------------------------------------