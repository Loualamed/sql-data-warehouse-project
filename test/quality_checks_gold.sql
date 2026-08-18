/*
Purpose:
Validate the integrity of the Gold-layer dimensional model by checking
customer and product surrogate-key uniqueness and verifying that every
sales fact can be linked to both its customer and product dimensions.
*/

/* Check uniqueness of customer_key in gold.dim_customers.
   Expectation: no rows are returned. */
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


/* Check uniqueness of product_key in gold.dim_products.
   Expectation: no rows are returned. */
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


/* Identify sales facts whose customer or product surrogate key
   does not resolve to a corresponding dimension record. */
SELECT 
    *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL
   OR c.customer_key IS NULL;
