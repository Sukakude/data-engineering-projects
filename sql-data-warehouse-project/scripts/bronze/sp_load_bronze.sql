/*
	This script will create a stored procedure that will perform a FULL LOAD using BULK INSERT. 
  It will make use of the TRUNCATE and Load method, where we will first empty out the table then load the data.
  
  Paramaters for the stored procedure:
    None.

  Returns:
    None
*/

CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '===================================';
		PRINT 'Loading Bronze Layer....';
		PRINT '===================================';

		PRINT '-----------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-----------------------------------';


		PRINT '>> TRUNCATING TABLE: Bronze.crm_cust_info';
		TRUNCATE TABLE Bronze.crm_cust_info; -- truncates the table

		SET @start_time = GETDATE();
		PRINT '>> INSERTING DATA INTO: Bronze.crm_cust_info';
		BULK INSERT Bronze.crm_cust_info
		FROM 'C:\Users\tshep\OneDrive\Desktop\Projects\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2, -- first row in the file will be skipped
			FIELDTERMINATOR = ',', -- seperates the data by a comma
			TABLOCK -- locks the entire table
		);
		SET @end_time = GETDATE();
		PRINT '>> LOADING DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

		PRINT '>> --------------------------------';


		PRINT '>> TRUNCATING TABLE: Bronze.crm_prd_info';
		TRUNCATE TABLE Bronze.crm_prd_info; -- truncates the table

		SET @start_time = GETDATE();
		PRINT '>> INSERTING DATA INTO: Bronze.crm_prd_info';
		BULK INSERT Bronze.crm_prd_info
		FROM 'C:\Users\tshep\OneDrive\Desktop\Projects\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2, -- first row in the file will be skipped
			FIELDTERMINATOR = ',', -- seperates the data by a comma
			TABLOCK -- locks the entire table
		);
		SET @end_time = GETDATE();
		PRINT '>> LOADING DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

		PRINT '>> --------------------------------';



		PRINT '>> TRUNCATING TABLE: Bronze.crm_sales_details';
		TRUNCATE TABLE Bronze.crm_sales_details; -- truncates the table
		
		SET @start_time = GETDATE();
		PRINT '>> INSERTING DATA INTO: Bronze.crm_sales_details';
		BULK INSERT Bronze.crm_sales_details
		FROM 'C:\Users\tshep\OneDrive\Desktop\Projects\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2, -- first row in the file will be skipped
			FIELDTERMINATOR = ',', -- seperates the data by a comma
			TABLOCK -- locks the entire table
		);
		SET @end_time = GETDATE();
		PRINT '>> LOADING DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

		PRINT '>> --------------------------------';

		PRINT '-----------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '-----------------------------------';

		PRINT '>> TRUNCATING TABLE: Bronze.erp_cust_az12';
		TRUNCATE TABLE Bronze.erp_cust_az12; -- truncates the table

		SET @start_time = GETDATE();
		PRINT '>> INSERTING DATA INTO: Bronze.erp_cust_az12';
		BULK INSERT Bronze.erp_cust_az12
		FROM 'C:\Users\tshep\OneDrive\Desktop\Projects\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2, -- first row in the file will be skipped
			FIELDTERMINATOR = ',', -- seperates the data by a comma
			TABLOCK -- locks the entire table
		);
		SET @end_time = GETDATE();
		PRINT '>> LOADING DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

		PRINT '>> --------------------------------';

		PRINT '>> TRUNCATING TABLE: Bronze.erp_loc_a101';
		TRUNCATE TABLE Bronze.erp_loc_a101; -- truncates the table

		SET @start_time = GETDATE();
		PRINT '>> INSERTING DATA INTO: Bronze.erp_loc_a101';
		BULK INSERT Bronze.erp_loc_a101
		FROM 'C:\Users\tshep\OneDrive\Desktop\Projects\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2, -- first row in the file will be skipped
			FIELDTERMINATOR = ',', -- seperates the data by a comma
			TABLOCK -- locks the entire table
		);
		SET @end_time = GETDATE();
		PRINT '>> LOADING DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

		PRINT '>> --------------------------------';


		PRINT '>> TRUNCATING TABLE: Bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2; -- truncates the table
		
		SET @start_time = GETDATE();
		PRINT '>> INSERTING DATA INTO: Bronze.erp_px_cat_g1v2';
		BULK INSERT Bronze.erp_px_cat_g1v2
		FROM 'C:\Users\tshep\OneDrive\Desktop\Projects\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2, -- first row in the file will be skipped
			FIELDTERMINATOR = ',', -- seperates the data by a comma
			TABLOCK -- locks the entire table
		);
		SET @end_time = GETDATE();
		PRINT '>> LOADING DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

		PRINT '>> --------------------------------';
		
		SET @batch_end_time = GETDATE();
		PRINT '===================================';
		PRINT 'LOADING COMPLETE';
		PRINT '>> TOTAL LOADING DURATION FOR BRONZE LAYER: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 's';
		PRINT '===================================';

	END TRY
	BEGIN CATCH
		PRINT '===================================';
		PRINT 'ERROR OCCURED DURING LOADING IN BRONZE LAYER';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '===================================';
	END CATCH;
END;



EXEC Bronze.load_bronze;
