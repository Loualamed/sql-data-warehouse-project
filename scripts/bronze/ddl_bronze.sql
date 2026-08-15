-- Purpose: Create the Bronze, Silver, and Gold schemas and define the raw Bronze-layer tables
-- used to store CRM and ERP source data for the data warehouse.


CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;


CREATE TABLE IF NOT EXISTS bronze.crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr           VARCHAR(50),
    cst_create_date    DATE
);

CREATE TABLE IF NOT EXISTS bronze.crm_prd_info (
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),	
    prd_cost     INT,
    prd_line     VARCHAR(50),
    prd_start_dt TIMESTAMP,
    prd_end_dt   TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bronze.crm_sales_details (
    sls_ord_num	 VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,	
    sls_price    INT
);

CREATE TABLE IF NOT EXISTS bronze.erp_cust_az12 (
    CID	  VARCHAR(50),
    BDATE DATE,
    GEN   VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101 (
    CID   VARCHAR(50),
    CNTRY VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS bronze.erp_px_cat_g1v2 (
    ID          VARCHAR(50),
    CAT	        VARCHAR(50),
    SUBCAT      VARCHAR(50),
    MAINTENANCE VARCHAR(50)
);

