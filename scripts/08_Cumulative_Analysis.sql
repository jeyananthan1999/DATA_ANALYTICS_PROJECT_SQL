/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
    - CTEs
===============================================================================
*/

-- Calculate the total sales per year per month and the running total of sales and moving average of sales per year per month

WITH monthly_sales AS (
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month_num,
        DATE_FORMAT(order_date, '%Y-%m') AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY 
        YEAR(order_date),
        MONTH(order_date),
        DATE_FORMAT(order_date, '%Y-%m')
	ORDER BY order_date
)

SELECT
    order_date,
    total_sales,
	-- Running total
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	-- Moving Average
    AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM monthly_sales;


