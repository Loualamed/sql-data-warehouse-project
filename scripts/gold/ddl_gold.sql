/*
Purpose:
Build the Gold-layer customer and product dimensions and the sales fact view
used for analytical reporting. The dimensions enrich CRM data with ERP
attributes, while the sales fact links transactions to the generated
customer and product surrogate keys.
*/

CREATE VIEW gold.dim_customers AS

SELECT
    row_number() OVER (ORDER BY cci.cst_id) AS customer_key,
    cci.cst_id AS customer_id,
    cci.cst_key AS customer_number,
    cci.cst_firstname AS first_name,
    cci.cst_lastname AS last_name,
    ela.cntry AS country,
    cci.cst_marital_status AS marital_status,

    -- Prefer the CRM gender; use the ERP value when CRM contains 'n/a'.
    CASE
        WHEN cci.cst_gndr != 'n/a' THEN cci.cst_gndr
        ELSE coalesce(eca.gen, 'n/a')
    END AS gender,

    eca.bdate AS birthdate,
    cci.cst_create_date AS create_date

FROM silver.crm_cust_info cci

LEFT JOIN silver.erp_cust_az12 eca
    ON cci.cst_key = eca.cid

LEFT JOIN silver.erp_loc_a101 ela
    ON cci.cst_key = ela.cid;


CREATE VIEW gold.dim_products AS

SELECT
    row_number() OVER (ORDER BY cp.prd_start_dt, cp.prd_key) AS product_key,
    cp.prd_id AS product_id,
    cp.prd_key AS product_number,
    cp.prd_nm AS product_name,
    cp.cat_id AS category_id,
    ep.cat AS category,
    ep.subcat AS subcat_category,
    ep.maintenance,
    cp.prd_cost AS cost,
    cp.prd_line AS product_line,
    cp.prd_start_dt AS start_date

FROM silver.crm_prd_info cp

LEFT JOIN silver.erp_px_cat_g1v2 ep
    ON cp.cat_id = ep.id

-- Only the current product version is exposed in the dimension.
WHERE cp.prd_end_dt IS NULL;


CREATE VIEW gold.fact_sales AS

SELECT
    cs.sls_ord_num AS order_number,
    dp.product_key,
    dc.customer_key,
    cs.sls_order_dt AS order_date,
    cs.sls_ship_dt AS shipping_date,
    cs.sls_due_dt AS due_date,
    cs.sls_sales AS sales_amount,
    cs.sls_quantity AS quantity,
    cs.sls_price AS price

FROM silver.crm_sales_details cs

LEFT JOIN gold.dim_customers dc
    ON cs.sls_cust_id = dc.customer_id

LEFT JOIN gold.dim_products dp
    ON cs.sls_prd_key = dp.product_number;
