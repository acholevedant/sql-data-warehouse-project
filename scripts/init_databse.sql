/*
-------------------------------------------------------------------------------------
 Title       : Data Warehouse Initialization Script
 Description : This script sets up the foundational structure for the Data Warehouse 
               project. It creates the 'DataWarehouse' database and organizes the 
               environment using a layered schema approach (Bronze, Silver, Gold) 
               based on the Medallion Architecture pattern.
Should check if database already exists, if so then drop the earlier and then recreate the DATABASE.

 Layers:
   • bronze - Raw/staging data
   • silver - Cleansed and transformed data
   • gold   - Aggregated and business-ready data

-------------------------------------------------------------------------------------
*/


-- Create Database 'DataWarehouse'

USE master;

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;

USE DataWarehouse;

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO
