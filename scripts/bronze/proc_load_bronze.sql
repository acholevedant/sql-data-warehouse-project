/*
-------------------------------------------------------------------------------------
 Title       : Bronze Layer Loader - Stored Procedure
 Description : This script creates the stored procedure [bronze.load_bronze] which 
               automates the ETL step of loading raw CSV files into the Bronze Layer 
               of the Data Warehouse following the Medallion Architecture.

               The procedure performs:
               - Truncation of all Bronze tables (to ensure idempotent loads)
               - BULK INSERT from CSV files into the Bronze tables
               - Time tracking for performance measurement
               - Basic error handling and logging

 Requirements:
 - Local file paths must be updated as per your environment
 - Proper access permissions required for BULK INSERT

-- Execute loader (useful for quick testing before procedure creation)
EXEC bronze.load_bronze;

-------------------------------------------------------------------------------------
*/

-- Create or alter procedure to load Bronze Layer
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE 
		@start_time DATETIME,
		@end_time DATETIME,
		@bronze_start_time DATETIME,
		@bronze_end_time DATETIME;

	BEGIN TRY
		SET @bronze_start_time = GETDATE();

		-- Logging Start of Bronze Layer Load
		PRINT '====================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '====================================================';

		-- ----------------------------- CRM TABLES -----------------------------
		PRINT '====================================================';
		PRINT 'Loading CRM Tables';
		PRINT '====================================================';

		-- crm_cust_info
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		-- crm_prd_info
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		-- crm_sales_details
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		-- ----------------------------- ERP TABLES -----------------------------
		PRINT '====================================================';
		PRINT 'Loading ERP Tables';
		PRINT '====================================================';

		-- erp_cust_az12
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		-- erp_loc_a101
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		-- erp_px_cat_g1v2
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\HP\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		-- Final Summary
		SET @bronze_end_time = GETDATE();
		PRINT '---------------------------------------------';
		PRINT '✅ Bronze Layer Load Completed';
		PRINT '>> Total Duration: ' + CAST(DATEDIFF(second, @bronze_start_time, @bronze_end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------------';

	END TRY
	BEGIN CATCH
		-- Error Handling Block
		PRINT '---------------------------------------------------';
		PRINT '❌ ERROR OCCURRED DURING BRONZE LAYER LOAD';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR STATE  : ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '---------------------------------------------------';
	END CATCH
END;
