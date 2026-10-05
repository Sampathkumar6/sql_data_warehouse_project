/*
----------------
Script note
----------------
1.	Creating stored procedure for repetetive use case
	Adding error handling
2.	Using builk insert to fill the tables we setup earlier
3.	checking for completeness of data inserted
4.	optional truncate to check for table empty
*/

--Stored procedure for all tables included within
create or alter procedure bronze.load_bronze as
begin
	declare @start_load datetime,@end_load datetime,@batch_starttime datetime,@batch_endtime datetime ;
	begin try
		set @batch_starttime = getdate();
		/*-------------------
		bronze.crm_cust_info
		*/-------------------
		print '=============================';
		print 'bronze layer';
		print '=============================';

		print '-----------------------------';
		print 'loading crm tables';
		print '-----------------------------';

		set @start_load = GETDATE();
		--making sure target table is empty before bulk insert
		truncate table bronze.crm_cust_info;

		--Inserting data from csv's to already created tables
		bulk insert bronze.crm_cust_info
		from 'D:\Sampath\SQL source\Project_git_sync_folder_structure\datasets\source_crm\cust_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
		--the below keyword is for performance improvization, looks at entire table during load.
			tablock
		);
		set @end_load = GETDATE();

		print 'load duration :' + cast(datediff(second,@start_load,@end_load) as nvarchar) +'seconds';	
		print '--------------'
		--checking data quality if uploaded bronze table
		--all data sense check
		--select * from bronze.crm_cust_info
		--count
		--select count(*) from bronze.crm_cust_info

		/*-------------------
		bronze.crm_prod_info
		*/-------------------
		set @start_load = GETDATE();
		--making sure target table is empty before bulk insert
		truncate table bronze.crm_prod_info;

		--Inserting data from csv's to already created tables
		bulk insert bronze.crm_prod_info
		from 'D:\Sampath\SQL source\Project_git_sync_folder_structure\datasets\source_crm\prd_info.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
		--the below keyword is for performance improvization, looks at entire table during load.
			tablock
		);
		set @end_load = GETDATE();
		print 'load duration :' + cast(datediff(second,@start_load,@end_load) as nvarchar) +'seconds';	
		print '--------------'
		--checking data quality if uploaded bronze table
		--all data sense check
		--select * from bronze.crm_prod_info
		--count
		--select count(*) from bronze.crm_prod_info

		/*-------------------
		bronze.crm_sales_details
		*/-------------------
		set @start_load = GETDATE();
		--making sure target table is empty before bulk insert
		truncate table bronze.crm_sales_details;

		--Inserting data from csv's to already created tables
		bulk insert bronze.crm_sales_details
		from 'D:\Sampath\SQL source\Project_git_sync_folder_structure\datasets\source_crm\sales_details.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
		--the below keyword is for performance improvization, looks at entire table during load.
			tablock
		);
		set @end_load = GETDATE();
		print 'load duration :' + cast(datediff(second,@start_load,@end_load) as nvarchar) +'seconds';	
		print '--------------'
		--checking data quality if uploaded bronze table
		--all data sense check
		--select * from bronze.crm_sales_details
		--count
		--select count(*) from bronze.crm_sales_details

		/*-------------------
		bronze.erp_cust_az12
		*/-------------------
		print '-----------------------------';
		print 'loading erp tables';
		print '-----------------------------';

		set @start_load = GETDATE();

		--making sure target table is empty before bulk insert
		truncate table bronze.erp_cust_az12;

		--Inserting data from csv's to already created tables
		bulk insert bronze.erp_cust_az12
		from 'D:\Sampath\SQL source\Project_git_sync_folder_structure\datasets\source_erp\CUST_AZ12.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
		--the below keyword is for performance improvization, looks at entire table during load.
			tablock
		);
		set @end_load = GETDATE();
		print 'load duration :' + cast(datediff(second,@start_load,@end_load) as nvarchar) +'seconds';	
		print '--------------'
		--checking data quality if uploaded bronze table
		--all data sense check
		--select * from bronze.erp_cust_az12
		--count
		--select count(*) from bronze.erp_cust_az12

		/*-------------------
		bronze.erp_loc_a101
		*/-------------------
		set @start_load = GETDATE();
		--making sure target table is empty before bulk insert
		truncate table bronze.erp_loc_a101;

		--Inserting data from csv's to already created tables
		bulk insert bronze.erp_loc_a101
		from 'D:\Sampath\SQL source\Project_git_sync_folder_structure\datasets\source_erp\LOC_A101.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
		--the below keyword is for performance improvization, looks at entire table during load.
			tablock
		);
		set @end_load = GETDATE();
		print 'load duration :' + cast(datediff(second,@start_load,@end_load) as nvarchar) +'seconds';	
		print '--------------'
		--checking data quality if uploaded bronze table
		--all data sense check
		--select * from bronze.erp_loc_a101
		--count
		--select count(*) from bronze.erp_loc_a101

		/*-------------------
		bronze.erp_px_cat_g1v2
		*/-------------------
		set @start_load = GETDATE();
		--making sure target table is empty before bulk insert
		truncate table bronze.erp_px_cat_g1v2;

		--Inserting data from csv's to already created tables
		bulk insert bronze.erp_px_cat_g1v2
		from 'D:\Sampath\SQL source\Project_git_sync_folder_structure\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
		--the below keyword is for performance improvization, looks at entire table during load.
			tablock
		);
		set @end_load = GETDATE();
		print 'load duration :' + cast(datediff(second,@start_load,@end_load) as nvarchar) +'seconds';	
		print '--------------'
		--checking data quality if uploaded bronze table
		--all data sense check
		--select * from bronze.erp_px_cat_g1v2
		--count
		--select count(*) from bronze.erp_px_cat_g1v2
		set @batch_endtime = getdate();
		print'bronze layer load is completed :' + cast(datediff(second,@batch_starttime,@batch_endtime) as nvarchar) + 'seconds';
	end try
	begin catch
		print '===========================';
		print 'error meggase' + error_message();
		print 'error number' + cast(error_number() as nvarchar);
		print '===========================';
	end catch
end