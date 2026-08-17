/*
Purpose: Load and standardize CRM and ERP source data from the Bronze layer into
the corresponding Silver-layer tables, applying deduplication, normalization,
data-quality corrections, and derived product validity dates.
*/

-- CRM customer master
INSERT INTO silver.crm_cust_info (
	cst_id, 
	cst_key, 
	cst_firstname,
	cst_lastname, 
	cst_marital_status, 
	cst_gndr, 
	cst_create_date
)
SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE 
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'n/a'   
	END AS cst_marital_status,
	CASE   
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		ELSE 'n/a'
	END AS cst_gndr,
	cst_create_date
FROM (
	SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL 
) t
WHERE flag_last = 1

-- CRM product master
INSERT INTO silver.crm_prd_info (
	prd_id, 
	prd_key,
	cat_id,
	prd_nm, 
	prd_cost, 
	prd_line, 
	prd_start_dt, 
	prd_end_dt
)
SELECT 
	prd_id, 
	substring(prd_key, 7, length(prd_key)) AS prd_key,
	substring(prd_key , 1, 5) AS cat_id,
	prd_nm, 
	coalesce(prd_cost, 0) AS prd_cost, 
	CASE 
		WHEN upper(trim(prd_line)) = 'M' THEN 'Mountain'
		WHEN UPPER(trim(prd_line)) = 'R' THEN 'Road'
		WHEN UPPER(trim(prd_line)) = 'T' THEN 'Touring'
		WHEN UPPER(trim(prd_line)) = 'S' THEN 'Other Sales'
		ELSE 'n/a'
	END AS prd_line, 
	prd_start_dt:: date,
	(lead(prd_start_dt::date) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1days'):: date AS prd_end_dt
FROM bronze.crm_prd_info;

-- CRM sales transactions
INSERT INTO silver.crm_sales_details (
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
		CASE   
		WHEN sls_order_dt <= 0 OR length(sls_order_dt :: text) != 8 THEN NULL 
		ELSE ((sls_order_dt :: text) :: date)
	END AS sls_order_dt,
	CASE   
		WHEN sls_ship_dt <= 0 OR length(sls_ship_dt :: text) != 8 THEN NULL 
		ELSE ((sls_ship_dt :: text) :: date)
	END AS sls_ship_dt,
	CASE   
		WHEN sls_due_dt <= 0 OR length(sls_due_dt :: text) != 8 THEN NULL 
		ELSE ((sls_due_dt :: text) :: date)
	END AS sls_due_dt, 
	CASE   
		WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * abs(sls_price) 
			THEN sls_quantity * abs(sls_price)
		ELSE sls_sales
	END AS sls_sales,
		sls_quantity,
	CASE 
		WHEN sls_price IS NULL OR sls_price <= 0 
			THEN sls_sales / NULLIF(sls_quantity, 0)
		ELSE sls_price 
	END AS sls_price
FROM bronze.crm_sales_details;

-- ERP customer demographics
INSERT INTO silver.erp_cust_az12 (
	cid,
	bdate,
	gen
)
SELECT 
	CASE 
		WHEN cid LIKE 'NAS%' THEN substring(cid, 4, length(cid))
		ELSE cid 
	END AS cid, 
	CASE 
		WHEN bdate >= current_date THEN NULL 
		ELSE bdate
	END AS bdate, 
	CASE 
		WHEN upper(trim(gen)) IN ('F', 'FEMALE') THEN 'Female'
		WHEN upper(trim(gen)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'n/a'
	END AS gen 
FROM bronze.erp_cust_az12

-- ERP customer locations
INSERT INTO silver.erp_loc_a101 (
	cid,
	cntry
)
SELECT 
	replace(cid, '-', '') AS cid, 
	CASE 
		WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
		WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
		WHEN UPPER(TRIM(cntry)) = '' OR cntry IS NULL THEN  'n/a'
		ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101

-- ERP product/category reference data 
INSERT INTO silver.erp_px_cat_g1v2 (
	id,
    cat,
    subcat, 
    maintenance
)
SELECT 
	id,
    cat,
    subcat, 
    maintenance
FROM bronze.erp_px_cat_g1v2 
