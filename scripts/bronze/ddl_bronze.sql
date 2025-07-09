/*
-------------------------------------------------------------------------------------
 Title       : Bronze Layer - Raw Data Table Creation
 Description : This script creates the foundational raw data tables in the "bronze" 
               schema of the DataWarehouse. These tables represent data directly 
               ingested from CRM and ERP systems with minimal/no transformation. 
               Used in Medallion Architecture for further processing in silver/gold.

-------------------------------------------------------------------------------------
*/

-- Drop and create CRM Customer Info table (raw CRM data)
IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);

-- Drop and create CRM Product Info table (product catalog from CRM)
IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE
);

-- Correcting data types for datetime columns in product info
ALTER TABLE bronze.crm_prd_info
ALTER COLUMN prd_start_dt DATETIME;

ALTER TABLE bronze.crm_prd_info
ALTER COLUMN prd_end_dt DATETIME;

-- Drop and create CRM Sales Details table (sales transactions from CRM)
IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
	sls_ord_num NVARCHAR(50),     -- Order number
	sls_prd_key NVARCHAR(50),     -- Product key
	sls_cust_id INT,              -- Customer ID
	sls_order_dt INT,             -- Dates stored as INT for raw ingestion
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

-- Drop and create ERP Customer Info table (alternate source of customer data)
IF OBJECT_ID ('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12 (
	cid NVARCHAR(50),             -- Customer ID
	bdate DATE,                   -- Birth date
	gen NVARCHAR(50)              -- Gender
);

-- Drop and create ERP Location Info table (customer-country mapping)
IF OBJECT_ID ('bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101 (
	cid NVARCHAR(50),             -- Customer ID
	cntry NVARCHAR(50)            -- Country
);

-- Drop and create ERP Product Category Mapping table
IF OBJECT_ID ('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2 (
	id NVARCHAR(50),              -- Product ID
	cat NVARCHAR(50),             -- Category
	subcat NVARCHAR(50),          -- Subcategory
	maintenance NVARCHAR(50)      -- Maintenance status/type
);
