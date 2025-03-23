/*
===============================================================================
Sales Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as customer name, category, subcategory, and cost.
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

-- Sales Report Query
WITH ProductMetrics AS (
    -- Calculate revenue, total orders, quantity sold, and segment products
    SELECT 
        pro.pro_product_name AS Product, 
        cat.cat_category_name AS Category, 
        pro.pro_list_price AS Cost,
        COUNT(DISTINCT od.od_order_id) AS Total_Orders,
        SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Sales,
        SUM(oi.od_it_quantity) AS Quantity_Sold,
        COUNT(DISTINCT od.od_customer_id) AS Unique_Customers,
        DATEDIFF(MONTH, MIN(CAST(od.od_order_date AS DATETIME)), MAX(CAST(od.od_order_date AS DATETIME))) + 1 AS Life_Span_Months,
        CASE 
            WHEN SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) >= 50000 THEN 'High Performer'
            WHEN SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) BETWEEN 20000 AND 49999 THEN 'Mid Performer'
            ELSE 'Low Performer'
        END AS Revenue_Segment
    FROM gold.sales_order_items oi
    JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
    JOIN gold.production_categories cat ON pro.pro_category_id = cat.cat_category_id
    JOIN gold.sales_orders od ON oi.od_it_order_id = od.od_order_id
    GROUP BY pro.pro_product_name, cat.cat_category_name, pro.pro_list_price
),
KPIs AS (
    -- Calculate recovery (months since last sale), AOR, and average monthly revenue
    SELECT 
        pro.pro_product_name AS Product, 
        MAX(DATEDIFF(MONTH, CAST(od.od_order_date AS DATETIME), GETDATE())) AS Recovery_Months,
        AVG(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Average_Order_Revenue,
        SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) / 
            NULLIF(DATEDIFF(MONTH, MIN(CAST(od.od_order_date AS DATETIME)), MAX(CAST(od.od_order_date AS DATETIME))) + 1, 0) AS Average_Monthly_Revenue
    FROM gold.sales_order_items oi
    JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
    JOIN gold.sales_orders od ON oi.od_it_order_id = od.od_order_id
    GROUP BY pro.pro_product_name
)
-- Consolidate the report
SELECT 
    pm.Product, 
    pm.Category, 
    pm.Cost, 
    pm.Total_Orders, 
    pm.Total_Sales, 
    pm.Quantity_Sold, 
    pm.Unique_Customers, 
    pm.Life_Span_Months, 
    pm.Revenue_Segment,
    k.Recovery_Months, 
    k.Average_Order_Revenue AS AOR, 
    k.Average_Monthly_Revenue
FROM ProductMetrics pm
JOIN KPIs k ON pm.Product = k.Product
ORDER BY pm.Total_Sales DESC;
