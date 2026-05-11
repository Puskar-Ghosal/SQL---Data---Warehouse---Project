/*
===============================================================================
 Script Name : init_database.sql
 Project     : Data Warehouse Project
 Author      : Puskar Ghosal
 PURPOSE:
    This script initializes the Data Warehouse environment by:
    1. Creating the main database
    2. Creating Medallion Architecture schemas:
        - Bronze Layer -> Raw ingestion layer
        - Silver Layer -> Cleaned and transformed data
        - Gold Layer   -> Business-ready analytics layer

  WHY EXISTENCE CHECKS ARE REQUIRED :
            WHY WE CHECK "IF NOT EXISTS":
              If we directly run CREATE DATABASE or CREATE SCHEMA again,
              SQL Server will throw an error because the object already exists.
          
              So before creating anything, we first check whether it already exists.
          
           BENEFIT:
              This makes the script SAFE TO RE-RUN multiple times without failure.
===============================================================================
*/

-- ============================================================================
-- STEP 1: Create Database
-- ============================================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'DataWarehouse'
)
BEGIN
    CREATE DATABASE DataWarehouse;
    PRINT 'Database [DataWarehouse] created successfully.';
END
ELSE
BEGIN
    PRINT 'Database [DataWarehouse] already exists.';
END;
GO

-- ============================================================================
-- STEP 2: Switch Database Context
-- ============================================================================

USE DataWarehouse;
GO

-- ============================================================================
-- STEP 3: Create Bronze Schema
-- Raw data ingestion layer
-- ============================================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'bronze'
)
BEGIN
    EXEC('CREATE SCHEMA bronze');
    PRINT 'Schema [bronze] created successfully.';
END
ELSE
BEGIN
    PRINT 'Schema [bronze] already exists.';
END;
GO

-- ============================================================================
-- STEP 4: Create Silver Schema
-- Cleaned and transformed layer
-- ============================================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'silver'
)
BEGIN
    EXEC('CREATE SCHEMA silver');
    PRINT 'Schema [silver] created successfully.';
END
ELSE
BEGIN
    PRINT 'Schema [silver] already exists.';
END;
GO

-- ============================================================================
-- STEP 5: Create Gold Schema
-- Business-ready analytics layer
-- ============================================================================

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'gold'
)
BEGIN
    EXEC('CREATE SCHEMA gold');
    PRINT 'Schema [gold] created successfully.';
END
ELSE
BEGIN
    PRINT 'Schema [gold] already exists.';
END;
GO
