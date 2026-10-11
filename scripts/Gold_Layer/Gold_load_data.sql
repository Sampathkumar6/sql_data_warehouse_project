/*
1. Final gold views
2. Adding surrogate key, just sys generated unique id (no meaning to facts or dim)
3. Adding foreign key, 
*/


--Customer dim
create view gold.dim_customers as
Select
row_number() over (order by ci.cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as lat_name,
la.cntry as country,
ci.cst_marital_status as marital_status,
case
	when ci.cst_gndr != 'Unknown' then ci.cst_gndr
	else coalesce(ca.gen , 'Unknown') end as gender,
ci.cst_create_date as create_date,
ca.b_date as birthdate
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key = ca.cst_id
left join silver.erp_loc_a101 la
on ci.cst_key = la.cst_id

--Product dim
create view gold.dim_product as
SELECT
row_number() over(order by prd_start_dt,prd_key) as product_key,
pi.prd_id as product_id,
pi.prd_key as product_num,
pi.prd_nm as product_name,
--pi.prd_end_dt as product_id, ignored since we already filtered
pi.cat_id as category_id,
pcat.cat as category_name,
pcat.subcat as sub_cateory,
pcat.maintenance as maintenance,
pi.prd_line as product_line,
pi.prd_cost as product_cost,
pi.prd_start_dt as start_date
from silver.crm_prod_info as pi
left join silver.erp_px_cat_g1v2 as pcat
on pi.cat_id = pcat.cat_id where pi.prd_end_dt is null-- where end date is empty meaning active, ignoring inactive products

--Sales Fact
create view gold.fact_sales as
SELECT
sls_ord_num as order_number,
pr.product_key,
cu.customer_key,
--sls_prd_key,
--sls_cust_id,
sls_order_dt as order_date,
sls_ship_dt as shipping_date,
sls_due_dt as due_date,
sls_sales as sales_amount,
sls_quantity as quantity,
sls_price as price
FROM silver.crm_sales_details sd
left join gold.dim_product pr
on sd.sls_prd_key = pr.product_num
left join gold.dim_customers cu
on sd.sls_cust_id = cu.customer_id