/* Data Quality Check of bronze.crm_cust_info 
=============================================== */
-- check customer key unwanted spaces
-- Expecctation : No Results
SELECT cst_key 
FROM bronze.crm_cust_info
WHERE cst_key != TRIM(cst_key)

-- Data Standarization & Consistency 

SELECT  DISTINCT cst_gndr -- To check how many disticnt values are therer 
FROM bronze.crm_cust_info

SELECT  DISTINCT cst_marital_status -- To check how many disticnt values are therer 
FROM bronze.crm_cust_info

/* Data Quality Check of bronze.crm_prd_info 
=============================================== */

-- Data Standarization 

SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

SELECT * FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt
-- hence we have issue with start adn end dates

SELECT *,
RANK() OVER( PARTITION BY prd_key ORDER BY prd_start_dt) as flag  
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt 

SELECT 
*,
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt )-1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key = 'AC-HE-HL-U509'

SELECT  * FROM bronze.crm_prd_info

/* Data Quality Check of bronze.crm_sales_details 
=============================================== */


SELECT * FROM bronze.crm_sales_details

SELECT *
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num) OR sls_ord_num IS NULL
-- Primary Key has no duplicates and no Null Values 

-- check for valid sls_prd_key and sls_cust_id

SELECT 
* 
FROM bronze.crm_sales_details
WHERE sls_cust_id  NOT IN 
(SELECT cst_id FROM bronze.crm_cust_info )

-- Result : Data Quality is fine No need to transofrm any thing 

-- Check for Invalid date 

SELECT 
NULLIF(sls_order_dt , 0 ) AS sls_order_dt 
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) < 8

-- from here we get two invalid date that can't be converted into date 

-- To check is shipping date is bigger than order date ?

SELECT 
*
FROM bronze.crm_sales_details 
WHERE sls_ship_dt < sls_order_dt OR sls_due_dt < sls_order_dt OR sls_ship_dt > sls_due_dt

-- its fine and hence no need to do transoformation 

-- check invalid sales 

SELECT 
	sls_sales AS old_sales,
	sls_quantity ,
	sls_price AS old_price,
	CASE 
		WHEN sls_sales IS NULL  OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
			THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END sls_sales,
	CASE WHEN sls_price IS NULL  OR sls_price <=0 
			THEN sls_sales/NULLIF(sls_quantity , 0) 
		ELSE sls_price
	END sls_price
FROM bronze.crm_sales_details
WHERE sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL 
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0

  /* Data Quality Check of bronze.erp_cust_az12
=============================================== */

SELECT * FROM bronze.erp_cust_az12

SELECT * FROM silver.crm_cust_info

-- fetch cid 
SELECT 
	cid,
	CASE 
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
		ELSE cid
	END cid
FROM bronze.erp_cust_az12

-- check data quality of bdate 

SELECT 
	bdate 
FROM bronze.erp_cust_az12
WHERE bdate < '1926-01-01' OR bdate > GETDATE()

-- check gender quality 

SELECT DISTINCT gen
FROM bronze.erp_cust_az12

  /* Data Quality Check of bronze.erp_loc_a101
=============================================== */

-- Check Data Quality 

SELECT 
*
FROM bronze.erp_loc_a101

SELECT cst_key FROM silver.crm_cust_info

-- there is an issue with cid as there is '-' symbol so we have to remove it 

SELECT 
	REPLACE(cid , '-' ,'') AS cid 
FROM bronze.erp_loc_a101

-- check cntry column 
SELECT DISTINCT cntry 
FROM bronze.erp_loc_a101
ORDER BY cntry

  /* Data Quality Check of bronze.erp_px_cat_g1v2
=============================================== */  

-- clean bronze.erp_px_cat_g1v2

SELECT * FROM bronze.erp_px_cat_g1v2

SELECT * FROM silver.crm_prd_info

-- since we already built cat_id in silver.crm_prd_info by matching with id of bronze.erp_px_Cat_g1v2 so we don't need to do anything 

-- Check for unwanted spaces 

SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- data quality is good 

-- to check data standarization 

SELECT DISTINCT maintenance 
FROM bronze.erp_px_cat_g1v2

-- The data quality of this table is very goodd so we just insert it into silver layer 








