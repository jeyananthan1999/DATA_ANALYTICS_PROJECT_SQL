/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT country from gold.dim_customers
order by country;

-- Retrieve a list of unique categories
SELECT DISTINCT category FROM gold.dim_products;       -- 5 unique categories including NULL

-- Retrieve a list of unique subategories
SELECT DISTINCT subcategory FROM gold.dim_products;    -- 37 unique subcategories including NULL

-- Retrieve a list of unique products
SELECT DISTINCT product_name FROM gold.dim_products;   -- 295 unique products

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;         
