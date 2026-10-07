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
--date format normalization and date validation by rules.
------------------------------------------------------------------------------------------
--Transformation bronze table and inserting to silver
------------------------------------------------------------------------------------------
--Stored procedure
create or alter procedure silver.load_layer as
begin
	--crm_cust_info
	print 'Truncating table crm_cust_info';
	truncate table silver.crm_cust_info;
	print 'Inserting table crm_cust_info';

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
	print 'Truncating table crm_prod_info';
	truncate table silver.crm_prod_info;
	print 'Inserting table crm_prod_info';

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

	--crm_sales_details
	print 'Truncating table crm_sales_details';
	truncate table silver.crm_sales_details;
	print 'Inserting table crm_sales_details';

	insert into silver.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_quantity, sls_price, sls_sales)
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
	--sls_sales as old_sls_sales,
	--sls_price as old_sls_price,
	sls_quantity,
	case
		when sls_price is null or sls_price <= 0
		then sls_sales / nullif(sls_quantity, 0)
		else sls_price
	end sls_price,
	case
		when sls_sales is null or sls_sales <= 0 or sls_sales!= (sls_quantity * abs(sls_price))
		then (sls_quantity * abs(sls_price))
		else sls_sales
	end sls_sales
	from bronze.crm_sales_details

	--erp_cust_az12
	print 'Truncating table erp_cust_az12';
	truncate table silver.erp_cust_az12;
	print 'Inserting table erp_cust_az12';

	insert into silver.erp_cust_az12(cst_id,b_date,gen)
	select
	--cst_id,
	case
		when cst_id like 'NAS%' then SUBSTRING(cst_id, 4, len(cst_id))
		else cst_id
	end cst_id,
	--b_date,
	case
		when try_convert(date,b_date,103) > getdate() then null
		else try_convert(date,b_date,103)
	end b_date,
	--gen,
	case
		when upper(trim(gen)) = 'M' then 'Male'
		when upper(trim(gen)) = 'F' then 'Female'
		when gen is null or trim(gen) = '' then 'Unknown'
		else trim(gen)
	end gen
	from bronze.erp_cust_az12

	--erp_loc_a101
	print 'Truncating table erp_loc_a101';
	truncate table silver.erp_loc_a101;
	print 'Inserting table erp_loc_a101';

	insert into silver.erp_loc_a101 (cst_id,cntry)
	SELECT
	--cst_id,
	replace(cst_id,'-','') cst_id,
	--cntry as old_cntry,
	case
		when trim(cntry) in ('DE','Germany') then 'Germany'
		when trim(cntry) in ('USA','US','United States') then 'United States'
		WHEN trim(cntry) is null or cntry = '' then 'Unknown'
		else trim(cntry)
	end cntry
	FROM bronze.erp_loc_a101

	--erp_px_cat_g1v2
	print 'Truncating table erp_px_cat_g1v2';
	truncate table silver.erp_px_cat_g1v2;
	print 'Inserting table erp_px_cat_g1v2';

	insert into silver.erp_px_cat_g1v2 (cat_id,cat,subcat,maintenance)
	SELECT
	id as cat_id,
	cat,
	replace(subcat,'-',' ') subcat,
	maintenance
	FROM bronze.erp_px_cat_g1v2

	print 'Silver layer completed, all tables loaded'
end