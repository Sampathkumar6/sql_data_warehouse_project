
/*
----------------
Script note
----------------
1. Building crm,erp tables
*/

--cust_info

create table bronze.crm_cust_info (
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date
);

--prod_info
create table bronze.crm_prod_info (
prd_id int,
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt date,
prd_end_dt date
);

--sales_details
create table bronze.crm_sales_details (
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id int,
--date type does not accept 0, so for now int
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int
);

--Building erp tables

--cust_az12

create table bronze.erp_cust_az12 (
cst_id  NVARCHAR(50),
b_date  NVARCHAR(20),--later in silver layer data type is managed accordingly
gen     NVARCHAR(50)
);


--loc_a101
create table bronze.erp_loc_a101 (
cst_id nvarchar(50),
cntry nvarchar(50)
);

--PX_CAT_G1V2
create table bronze.erp_px_cat_g1v2 (
id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(50)
);