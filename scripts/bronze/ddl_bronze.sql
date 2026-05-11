/*
===============================================================================
 Bronze Layer Table Creation Script
===============================================================================

PURPOSE:
--------
This script creates all required tables for the Bronze Layer in the
Data Warehouse project.

The Bronze Layer stores raw data exactly as received from source systems
before any transformation or cleaning.

SOURCE SYSTEMS:
---------------
1. CRM System
2. ERP System

WHAT THIS SCRIPT DOES:
----------------------
1. Checks whether a table already exists.
2. Drops the existing table if found.
3. Creates a fresh new table structure.
4. Defines columns and data types for raw data storage.

WHY WE USE "IF OBJECT_ID ... DROP TABLE":
-----------------------------------------
Before creating a table, we first check if it already exists.

If the table already exists:
- SQL Server will throw an error during CREATE TABLE.
- Old table structure may conflict with the new structure.

So we:
1. Check existence using OBJECT_ID()
2. Drop the old table
3. Recreate a clean table

SYNTAX USED:
------------
IF OBJECT_ID('table_name', 'U') IS NOT NULL
	DROP TABLE table_name;

'U' means:
-----------
User-defined table

===============================================================================
CRM TABLES
===============================================================================

1. bronze.crm_cust_info
-----------------------
Stores customer information from CRM system.

Columns:
- cst_id             : Customer ID
- cst_key            : Customer key
- cst_firstname      : First name
- cst_lastname       : Last name
- cst_marital_status : Marital status
- cst_gndr           : Gender
- cst_create_date    : Customer creation date

-------------------------------------------------------------------------------

2. bronze.crm_prd_info
----------------------
Stores product information from CRM system.

Columns:
- prd_id         : Product ID
- prd_key        : Product key
- prd_nm         : Product name
- prd_cost       : Product cost
- prd_line       : Product category/line
- prd_start_dt   : Product start date
- prd_end_dt     : Product end date

-------------------------------------------------------------------------------

3. bronze.crm_sales_details
---------------------------
Stores sales transaction details.

Columns:
- sls_ord_num    : Order number
- sls_prd_key    : Product key
- sls_cust_id    : Customer ID
- sls_order_dt   : Order date
- sls_ship_dt    : Shipping date
- sls_due_dt     : Due date
- sls_sales      : Total sales amount
- sls_quantity   : Quantity sold
- sls_price      : Product price

===============================================================================
ERP TABLES
===============================================================================

4. bronze.erp_loc_a101
----------------------
Stores customer country/location data.

Columns:
- cid     : Customer ID
- cntry   : Country

-------------------------------------------------------------------------------

5. bronze.erp_cust_az12
-----------------------
Stores additional ERP customer information.

Columns:
- cid     : Customer ID
- bdate   : Birth date
- gen     : Gender

-------------------------------------------------------------------------------

6. bronze.erp_px_cat_g1v2
-------------------------
Stores product category information.

Columns:
- id           : Product ID
- cat          : Category
- subcat       : Sub-category
- maintenance  : Maintenance type

===============================================================================
WHY THIS SCRIPT IS IMPORTANT:
-----------------------------
This script builds the foundation of the Data Warehouse.

Without tables:
- Data cannot be loaded
- ETL process cannot start
- Bronze layer cannot store raw files

This is usually the FIRST step in a Data Warehouse project.

===============================================================================
WORKFLOW:
---------
Step 1 → Create Database
Step 2 → Create Schemas
Step 3 → Create Bronze Tables   ← (THIS SCRIPT)
Step 4 → Load Raw CSV Data
Step 5 → Transform Data
Step 6 → Build Silver Layer 
Step 7 → Build Gold Layer 
Step 8 → Exploratory Data Analysis ( EDA ) 

===============================================================================
*/

USE DataWareHouse

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL 
	DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
	cst_id INT , 
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE

) ;

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL 
	DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
prd_id INT ,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME
);

IF OBJECT_ID('bronze.crm_sales_details ', 'U') IS NOT NULL 
	DROP TABLE bronze.crm_sales_details ;

CREATE TABLE bronze.crm_sales_details (
sls_ord_num NVARCHAR(50) , 
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT ,
sls_price INT 
) ; 

IF OBJECT_ID('bronze.erp_loc_a101 ', 'U') IS NOT NULL 
	DROP TABLE bronze.erp_loc_a101 ;

CREATE TABLE bronze.erp_loc_a101 (
cid NVARCHAR(50) , 
cntry NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL 
	DROP TABLE bronze.erp_cust_az12 ;

CREATE TABLE bronze.erp_cust_az12 ( 
cid NVARCHAR(50),
bdate DATE ,
gen NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL 
	DROP TABLE bronze.erp_px_cat_g1v2 ;

CREATE TABLE bronze.erp_px_cat_g1v2 ( 
id NVARCHAR(50) , 
cat NVARCHAR(50),
subcat NVARCHAR(50) , 
maintenance NVARCHAR(50)
);

