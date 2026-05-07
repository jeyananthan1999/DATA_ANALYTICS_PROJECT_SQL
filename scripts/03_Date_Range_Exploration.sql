/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in years as well as months 
SELECT 
	MIN(order_date) as first_order_date,
	MAX(order_date) as last_order_date,
    TIMESTAMPDIFF(YEAR, MIN(order_date), MAX(order_date)) as range_years,
	TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) as range_months,
	TIMESTAMPDIFF(DAY, MIN(order_date), MAX(order_date)) as range_days
from gold.fact_sales;

-- Find the youngest and oldest customer based on birthdate
SELECT
    MIN(birthdate) AS oldest_birthdate,
    TIMESTAMPDIFF(YEAR, MIN(birthdate), current_date()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    TIMESTAMPDIFF(YEAR, MAX(birthdate), current_date()) AS youngest_age
FROM gold.dim_customers;