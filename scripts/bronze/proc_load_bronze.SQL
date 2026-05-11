/*
===============================================================================
 Stored Procedure : bronze.load_bronze
===============================================================================

PURPOSE:
--------
This stored procedure is used to load raw data files (CSV files) into the 
Bronze Layer tables of the Data Warehouse.

The Bronze Layer acts as the first storage layer where raw source data is 
ingested exactly as received from CRM and ERP systems.

WHAT THIS PROCEDURE DOES:
-------------------------
1. Truncates (clears) existing data from bronze tables.
2. Loads fresh data from CSV files using BULK INSERT.
3. Separately loads CRM and ERP source data.
4. Tracks loading duration for each table.
5. Displays execution logs using PRINT statements.
6. Handles errors using TRY...CATCH block.

TABLES LOADED:
--------------
CRM Tables:
- bronze.crm_cust_info
- bronze.crm_prd_info
- bronze.crm_sales_details

ERP Tables:
- bronze.erp_cust_az12
- bronze.erp_loc_a101
- bronze.erp_px_cat_g1v2

IMPORTANT CONCEPTS USED:
------------------------
- CREATE OR ALTER PROCEDURE :
    Creates the procedure if it does not exist,
    otherwise updates the existing one.

- TRUNCATE TABLE :
    Removes all existing records quickly before loading fresh data.

- BULK INSERT :
    Imports large CSV files into SQL Server tables efficiently.

- TRY...CATCH :
    Handles runtime errors and displays error information.

- GETDATE() + DATEDIFF() :
    Used for measuring data load execution time.

WHY THIS PROCEDURE IS IMPORTANT:
--------------------------------
Instead of manually loading files one by one,
this procedure automates the entire Bronze Layer ingestion process.

BENEFITS:
---------
- Faster data loading
- Reusable ETL process
- Better monitoring using logs
- Easier debugging with error handling
- Supports Data Warehouse automation

EXECUTION:
----------
Run the procedure using:

EXEC bronze.load_bronze

WORKFLOW:
---------
Step 1 → Create Database
Step 2 → Create Schemas
Step 3 → Create Bronze Tables   
Step 4 → Load Raw CSV Data    ← (THIS SCRIPT)
Step 5 → Transform Data
Step 6 → Build Silver & Gold Layers
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @starttime DATETIME , @endtime DATETIME , @batch_start_time DATETIME , @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE()
		PRINT '====================================='
		PRINT 'Loading Bronze Layer'
		PRINT '====================================='

		PRINT '-------------------------------------'
		PRINT 'Loading CRM Table' 
		PRINT '-------------------------------------'

		SET @starttime = GETDATE();
		PRINT 'Truncating Table : bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT 'Data Inserted to : bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\PUSKAR\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @endtime = GETDATE();
		PRINT 'Load Duration : ' + CAST(DATEDIFF(second , @starttime , @endtime) AS NVARCHAR ) + 'seconds'
		PRINT'-----------------'

		SET @starttime = GETDATE();
		PRINT 'Truncating Table : bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT 'Data Inserted to : bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\PUSKAR\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @endtime = GETDATE();
		PRINT 'Load Duration : ' + CAST(DATEDIFF(second , @starttime , @endtime) AS NVARCHAR ) + 'seconds'
		PRINT'-----------------'

		SET @starttime = GETDATE();
		PRINT 'Truncating Table : crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details

		PRINT 'Data Inserted to : crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\PUSKAR\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @endtime = GETDATE();
		PRINT 'Load Duration : ' + CAST(DATEDIFF(second , @starttime , @endtime) AS NVARCHAR ) + 'seconds'
		

		PRINT '-------------------------------------'
		PRINT 'Loading ERP Table' 
		PRINT '-------------------------------------'

		SET @starttime = GETDATE();
		PRINT 'Truncating Table : bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12

		PRINT 'Data Inserted to : bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\PUSKAR\Desktop\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @endtime = GETDATE();
		PRINT 'Load Duration : ' + CAST(DATEDIFF(second , @starttime , @endtime) AS NVARCHAR ) + 'seconds'
		PRINT'-----------------'

		SET @starttime = GETDATE();
		PRINT 'Truncating Table : bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101

		PRINT 'Data Inserted to : bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\PUSKAR\Desktop\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @endtime = GETDATE();
		PRINT 'Load Duration : ' + CAST(DATEDIFF(second , @starttime , @endtime) AS NVARCHAR ) + 'seconds'
		PRINT'-----------------'

		SET @starttime = GETDATE();
		PRINT 'Truncating Table : bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2

		PRINT 'Data Inserted to : bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\PUSKAR\Desktop\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		)
		SET @endtime = GETDATE();
		PRINT 'Load Duration : ' + CAST(DATEDIFF(second , @starttime , @endtime) AS NVARCHAR ) + 'seconds'
		PRINT'-----------------'

		SET @batch_end_time = GETDATE() ;
		PRINT '================================='
		PRINT 'Loading Bronze Layer is Completed'
		PRINT ' Total Duration ' + CAST(DATEDIFF(SECOND , @batch_start_time , @batch_end_time) AS NVARCHAR )
		PRINT '================================='

	END TRY 
	BEGIN CATCH
		PRINT '================================='
		PRINT ' ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT ' Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '================================='
	END CATCH 
END 

EXEC bronze.load_bronze
