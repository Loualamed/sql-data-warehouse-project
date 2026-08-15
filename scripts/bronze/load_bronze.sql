-- Purpose: Refresh the Bronze layer by removing previously loaded source data 
-- and reloading the latest CRM and ERP CSV files into their corresponding tables.


TRUNCATE TABLE bronze.crm_cust_info;   
\copy bronze.crm_cust_info FROM 'sql-data-warehouse/datasets/source_crm/cust_info.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

TRUNCATE TABLE bronze.crm_prd_info;
\copy bronze.crm_prd_info FROM 'sql-data-warehouse/datasets/source_crm/prd_info.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

TRUNCATE TABLE bronze.crm_sales_details;
\copy bronze.crm_sales_details FROM 'sql-data-warehouse/datasets/source_crm/sales_details.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

TRUNCATE TABLE bronze.erp_cust_az12;
\copy bronze.erp_cust_az12 FROM 'sql-data-warehouse/datasets/source_erp/CUST_AZ12.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

TRUNCATE TABLE bronze.erp_loc_a101;
\copy bronze.erp_loc_a101 FROM 'sql-data-warehouse/datasets/source_erp/LOC_A101.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

TRUNCATE TABLE bronze.erp_px_cat_g1v2;
\copy bronze.erp_px_cat_g1v2 FROM 'sql-data-warehouse/datasets/source_erp/PX_CAT_G1V2.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
