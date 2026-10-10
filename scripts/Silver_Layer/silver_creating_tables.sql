
/*
----------------
Script note
----------------
1. Building silver crm,erp tables
*/

--cust_info
if object_id ('silver.crm_cust_info','U') is not null
	drop table silver.crm_cust_info;

create table silver.crm_cust_info (
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date,
dwh_create_date datetime2 default getdate()
);

--prod_info
if object_id ('silver.crm_prod_info','U') is not null
	drop table silver.crm_prod_info;
--old
create table silver.crm_prod_info (
prd_id int,
cat_id nvarchar(50),
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt date,
prd_end_dt date,
dwh_create_date datetime2 default getdate()
);

--sales_details
if object_id ('silver.crm_sales_details','U') is not null
	drop table silver.crm_sales_details;

create table silver.crm_sales_details (
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id int,
--date type does not accept 0, so for now int
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales int,
sls_quantity int,
sls_price int,
dwh_create_date datetime2 default getdate()
);

--Building erp tables

--cust_az12
if object_id ('silver.erp_cust_az12','U') is not null
	drop table silver.erp_cust_az12;

create table silver.erp_cust_az12 (
cst_id  NVARCHAR(50),
b_date  date,--later in silver layer data type is managed accordingly
gen     NVARCHAR(50),
dwh_create_date datetime2 default getdate()
);

--loc_a101
if object_id ('silver.erp_loc_a101','U') is not null
	drop table silver.erp_loc_a101;

create table silver.erp_loc_a101 (
cst_id nvarchar(50),
cntry nvarchar(50),
dwh_create_date datetime2 default getdate()
);

--PX_CAT_G1V2
if object_id ('silver.erp_px_cat_g1v2','U') is not null
	drop table silver.erp_px_cat_g1v2;

create table silver.erp_px_cat_g1v2 (
cat_id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(50),
dwh_create_date datetime2 default getdate()
);