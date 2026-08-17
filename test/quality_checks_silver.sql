/*
Purpose: Perform data-quality checks on Bronze-layer CRM and ERP data by
inspecting raw records and validating the transformations, standardizations,
deduplication rules, date handling, and numeric consistency expected in Silver.
*/

-- ============================================================
-- CRM CUSTOMER INFORMATION
-- ============================================================

-- Inspect the complete CRM customer source data for general quality issues.
SELECT * 
FROM bronze.crm_cust_info;

-- Identify customer first names that contain leading or trailing whitespace.
SELECT TRIM(cst_firstname) AS cst_firstname
FROM bronze.crm_cust_info 
WHERE cst_firstname != TRIM(cst_firstname);

-- Identify customer last names that contain leading or trailing whitespace.
SELECT TRIM(cst_lastname) AS cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Validate marital-status source codes against their expected standardized values.
SELECT DISTINCT 
    cst_marital_status,
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'   
    END AS cst_marital_status
FROM bronze.crm_cust_info;

-- Validate gender source codes against their expected standardized values.
SELECT DISTINCT 
    cst_gndr,
    CASE   
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        ELSE 'n/a'
    END AS cst_gndr
FROM bronze.crm_cust_info;

-- Verify that the most recent record is selected for each customer ID.
SELECT 
    *
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY cst_id 
            ORDER BY cst_create_date DESC
        ) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL 
) t
WHERE flag_last = 1;


-- ============================================================
-- CRM PRODUCT INFORMATION
-- ============================================================

-- Inspect the complete CRM product source data for general quality issues.
SELECT * 
FROM bronze.crm_prd_info;

-- Verify that the product key and category ID are extracted from the expected positions.
SELECT 
    substring(prd_key, 7, length(prd_key)) AS prd_key,
    substring(prd_key, 1, 5) AS cat_id 
FROM bronze.crm_prd_info;

-- Check the default value applied when product cost is missing.
SELECT COALESCE(prd_cost, 0) AS prd_cost
FROM bronze.crm_prd_info;

-- Validate product-line source codes against their expected standardized values.
SELECT DISTINCT 
    prd_line,
    CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        ELSE 'n/a'
    END AS prd_line
FROM bronze.crm_prd_info;

-- Verify that each product version ends one day before the next version starts.
SELECT 
    prd_start_dt::date,
    (
        LEAD(prd_start_dt::date) OVER (
            PARTITION BY prd_key 
            ORDER BY prd_start_dt
        ) - INTERVAL '1 day'
    )::date AS prd_end_dt
FROM bronze.crm_prd_info;


-- ============================================================
-- CRM SALES DETAILS
-- ============================================================

-- Inspect the complete CRM sales source data for general quality issues.
SELECT * 
FROM bronze.crm_sales_details;

-- Validate the format of order, shipping, and due dates before date conversion.
SELECT
    CASE   
        WHEN sls_order_dt <= 0 
             OR length(sls_order_dt::text) != 8 
            THEN NULL 
        ELSE (sls_order_dt::text)::date
    END AS sls_order_dt,
    CASE   
        WHEN sls_ship_dt <= 0 
             OR length(sls_ship_dt::text) != 8 
            THEN NULL 
        ELSE (sls_ship_dt::text)::date
    END AS sls_ship_dt,
    CASE   
        WHEN sls_due_dt <= 0 
             OR length(sls_due_dt::text) != 8 
            THEN NULL 
        ELSE (sls_due_dt::text)::date
    END AS sls_due_dt
FROM bronze.crm_sales_details;

-- Identify sales records with missing, invalid, or inconsistent financial measures.
SELECT
    CASE   
        WHEN sls_sales IS NULL 
             OR sls_sales <= 0 
             OR sls_sales != sls_quantity * ABS(sls_price) 
            THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE 
        WHEN sls_price IS NULL 
             OR sls_price <= 0 
            THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price 
    END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0;


-- ============================================================
-- ERP CUSTOMER INFORMATION
-- ============================================================

-- Inspect the complete ERP customer source data for general quality issues.
SELECT * 
FROM bronze.erp_cust_az12;

-- Verify that the NAS prefix is removed from ERP customer IDs when present.
SELECT 
    cid,
    CASE 
        WHEN cid LIKE 'NAS%' 
            THEN substring(cid, 4, length(cid))
        ELSE cid 
    END AS cid
FROM bronze.erp_cust_az12;

-- Identify birth dates that are today or in the future and would be invalidated.
SELECT 
    bdate,
    CASE 
        WHEN bdate >= current_date 
            THEN NULL 
        ELSE bdate
    END AS bdate
FROM bronze.erp_cust_az12
WHERE bdate >= current_date;

-- Validate ERP gender values against the expected standardized categories.
SELECT DISTINCT 
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gen
FROM bronze.erp_cust_az12;


-- ============================================================
-- ERP LOCATION INFORMATION
-- ============================================================

-- Inspect the complete ERP location source data for general quality issues.
SELECT * 
FROM bronze.erp_loc_a101;

-- Verify that hyphens are removed from ERP customer IDs.
SELECT 
    REPLACE(cid, '-', '') AS cid 
FROM bronze.erp_loc_a101;

-- Validate country values against the expected standardized country names.
SELECT DISTINCT 
    cntry,
    CASE 
        WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
        WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
        WHEN UPPER(TRIM(cntry)) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry
FROM bronze.erp_loc_a101;


-- ============================================================
-- ERP PRODUCT CATEGORY INFORMATION
-- ============================================================

-- Inspect the complete ERP product-category source data for quality review.
SELECT * 
FROM bronze.erp_px_cat_g1v2;
