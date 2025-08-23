/*
	This script performs the ETL process to seed dat into the 'Silver' schema tables from the 'Bronze' schema.

	Parameters:
		- None

	Usage:
		- EXEC Silver.load_silver
*/

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE Silver.load_silver
AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE(); -- tracks the start time of the entire batch
		
		PRINT '>> TRUNCATING TABLE: Silver.crm_cust_info'
		TRUNCATE TABLE Silver.crm_cust_info
		
		SET @start_time = GETDATE();  -- tracks the start time for loading the crm_cust_info table
		PRINT '>> INSERTING INTO TABLE: Silver.crm_cust_info '
		INSERT INTO Silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gnder, cst_create_date)
		SELECT cst_id, 
				cst_key, 
				TRIM(cst_firstname) as cst_firstname, -- Remove whitespace
				TRIM(cst_lastname) as cst_lastname, 
				CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married' -- Data normalization
					 WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
					 ELSE 'n/a' -- Handle missing values
				END cst_marital_status, 
				CASE WHEN UPPER(TRIM(cst_gnder)) = 'F' THEN 'Female'
					 WHEN UPPER(TRIM(cst_gnder)) = 'M' THEN 'Male'
					 ELSE 'n/a'
				END cst_gnder,
				cst_create_date
		FROM (
				SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last 
				FROM Bronze.crm_cust_info
				WHERE cst_id IS NOT NULL
		)t WHERE flag_last = 1 -- Remove duplicates by selecting the most recent record
		
		SET @end_time = GETDATE(); -- tracks the end time for loading the crm_cust_info table

		PRINT '>> LOADING DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

		PRINT '>> --------------------------------';

		PRINT '>> TRUNCATING TABLE: Silver.crm_prd_info'
		TRUNCATE TABLE Silver.crm_prd_info

		SET @start_time = GETDATE(); -- tracks the start time for loading the crm_prd_info table
		PRINT '>> INSERTING INTO TABLE: Silver.crm_prd_info'
		INSERT INTO Silver.crm_prd_info(prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
		SELECT prd_id, 
			   REPLACE(SUBSTRING(prd_key, 1, 5),'-','_')as cat_id, -- Extract the Category ID
			   SUBSTRING(prd_key, 7, LEN(prd_key)) as prd_key,  -- Extract the Product ID
			   prd_nm,
			   ISNULl(prd_cost, 0) as prd_cost,
			   CASE UPPER(TRIM(prd_line)) 
					WHEN 'M' THEN 'Mountain'
					WHEN 'R' THEN 'Road'
					WHEN 'S' THEN 'Other Sales'
					WHEN 'T' THEN 'Touring'
					ELSE 'n/a'
			   END AS prd_line, -- Map product line codes to descriptive values
			   CAST(prd_start_dt AS DATE) prd_start_dt,
			   CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1  AS DATE) AS prd_end_dt -- Calculates the end date as one day before the next start date
		FROM Bronze.crm_prd_info;
		SET @end_time = GETDATE(); -- tracks the end time for loading the crm_cust_info table
		PRINT '>> LOADING DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

		PRINT '>> --------------------------------';


		PRINT '>> TRUNCATING TABLE: Silver.crm_sales_details'
		TRUNCATE TABLE Silver.crm_sales_details

		SET @start_time = GETDATE(); -- tracks the start time for loading the crm_sales_details table
		PRINT '>> INSERTING INTO TABLE: Silver.crm_sales_details'
		INSERT INTO Silver.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			-- converts the order date column to date object
			CASE 
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) <> 8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
			-- converts ship date column to date object
			CASE 
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) <> 8 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
			-- convert due date column to date object
			CASE 
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) <> 8 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
			CASE 
				WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales <> sls_quantity * ABS(sls_price) 
					THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
			END AS sls_sales,
			sls_quantity,
			CASE 
				WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0)
				ELSE sls_price
			END AS sls_price
		FROM Bronze.crm_sales_details;

		SET @end_time = GETDATE(); -- tracks the end time for loading the crm_sales_details table
		PRINT '>> LOADING DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

		PRINT '>> --------------------------------';

		PRINT '>> TRUNCATING TABLE: Silver.erp_cust_az12'
		TRUNCATE TABLE Silver.erp_cust_az12

		SET @start_time = GETDATE(); -- tracks the start time for loading the erp_cust_az12 table
		PRINT '>> INSERTING INTO TABLE: Silver.erp_cust_az12'
		INSERT INTO Silver.erp_cust_az12 (cid, bdate, gen)
		SELECT 
			CASE 
				WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
				ELSE cid
			END AS cid,
			-- Check for erronous values in the birth date e.g birthday in the future
			CASE 
				WHEN bdate > GETDATE() THEN NULL
				ELSE bdate
			END AS bdate, 
			-- Standardize the gender column
			CASE 
				WHEN TRIM(UPPER(gen)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN TRIM(UPPER(gen)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'n/a'
			END AS gen		
		FROM Bronze.erp_cust_az12;
		SET @end_time = GETDATE(); -- tracks the end time for loading the erp_cust_az12 table
		PRINT '>> LOADING DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

		PRINT '>> --------------------------------';

		---- *********** LOCATIONS TABLE *********
		PRINT '>> TRUNCATING TABLE: Silver.erp_loc_a101'
		TRUNCATE TABLE Silver.erp_loc_a101

		SET @start_time = GETDATE(); -- tracks the start time for loading the erp_loc_a101 table
		PRINT '>> INSERTING INTO TABLE: Silver.erp_loc_a101'
		INSERT INTO Silver.erp_loc_a101 (cid, cntry)
		SELECT 
			REPLACE(cid, '-', '') AS cid, 
			CASE 
				WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
				WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
				ELSE cntry
			END AS cntry
		FROM Bronze.erp_loc_a101;

		SET @end_time = GETDATE(); -- tracks the end time for loading the erp_loc_a101 table
		PRINT '>> LOADING DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

		PRINT '>> --------------------------------';

		-- ********** Category Table ************
		PRINT '>> TRUNCATING TABLE: Silver.erp_px_cat_g1v2'
		TRUNCATE TABLE Silver.erp_px_cat_g1v2

		SET @start_time = GETDATE(); -- tracks the start time for loading the erp_px_cat_g1v2 table
		PRINT '>> INSERTING INTO TABLE: Silver.erp_px_cat_g1v2'
		INSERT INTO Silver.erp_px_cat_g1v2(id, cat, subcat, maintainance)
		SELECT 
			id, 
			cat, 
			subcat, 
			maintainance 
		FROM Bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE(); -- tracks the start time for loading the erp_px_cat_g1v2 table
		PRINT '>> LOADING DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 's';

		PRINT '>> --------------------------------';

		SET @batch_end_time = GETDATE(); -- tracks the total time for loading the entire batch into the Silver layer
		PRINT '===================================';
		PRINT 'LOADING COMPLETE';
		PRINT '>> TOTAL LOADING DURATION FOR SILVER LAYER: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 's';
		PRINT '===================================';
	END TRY
	BEGIN CATCH
		PRINT '===================================';
		PRINT 'ERROR OCCURED DURING LOADING IN SILVER LAYER';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '===================================';
	END CATCH
END

EXEC Silver.load_silver;
