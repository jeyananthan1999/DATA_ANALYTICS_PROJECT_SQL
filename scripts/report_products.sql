/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================
DROP VIEW IF EXISTS gold.report_products;

CREATE VIEW gold.report_products AS

WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
SELECT
	f.order_number,
	f.order_date,
	f.customer_key,
	f.sales_amount,
	f.quantity,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost 
FROM gold.fact_sales f 
LEFT JOIN gold.dim_products p 
ON f.product_key = p.product_key
WHERE f.order_date is NOT NULL              -- only consider valid sales date
),


product_aggregations AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) as lifespan,
	MAX(order_date) as last_sale_date,
	COUNT(DISTINCT order_number) as total_orders,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(sales_amount) as total_sales,
	SUM(quantity) as total_quantity,
    ROUND(SUM(sales_amount)/NULLIF(SUM(quantity),0),2) as average_selling_price
FROM base_query
GROUP BY
	product_key,
	product_name,
	category,
	subcategory,
	cost
)

/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	TIMESTAMPDIFF(MONTH,last_sale_date,current_date()) as recency_in_months,
	CASE
		WHEN total_sales > 50000 THEN "High-Performer"
		WHEN total_sales < 10000 THEN "Low-Performer"
		ELSE "Mid-Range"
	END AS product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	average_selling_price,

	 -- Average Order Revenue (AOR)
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE ROUND((total_sales/total_orders),2)
	END as average_order_revenue,

	-- Average Monthly Revenue
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE ROUND((total_sales / lifespan),2)
	END AS average_monthly_revenue

FROM product_aggregations;

