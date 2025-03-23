/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Essential Fields:
        - Includes Products Name, Category, and Cost for a detailed view.
    2. Segmentation:
        - Segments products as High, Mid and Low Performer based on revenue.
    3. Product-Level Metrics:
        - Aggregate Total Orders, Total Sales, Quantity Sold, Unique Customers, and Lifespan in Months.
    4. KPIs:
        - Recency: Months since the last sale.
        - Average Order Revenue (AOR): Revenue per order.
        - Average Monthly Revenue: Total sales divided by the product's lifespan.
    5. Enhancements:
        - Organized results by Total Sales to identify top-performer products.
        - Enhanced grouping by sub-categories for more granular analysis.
===============================================================================
*/

-- Product Report
WITH ProductMetrics AS (
    -- Aggregate product-level metrics
    SELECT 
        pro.pro_product_name AS Product_Name,
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
    FROM gold.sales_orders od
    JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
    JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
    JOIN gold.production_categories cat ON pro.pro_category_id = cat.cat_category_id
    GROUP BY pro.pro_product_name, cat.cat_category_name, pro.pro_list_price
),
KPIs AS (
    -- Calculate KPIs: Recency, Average Order Revenue (AOR), and Average Monthly Revenue
    SELECT 
        pro.pro_product_name AS Product_Name,
        MAX(DATEDIFF(MONTH, CAST(od.od_order_date AS DATETIME), GETDATE())) AS Recency_Months,
        AVG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
            OVER (PARTITION BY pro.pro_product_id) AS Average_Order_Revenue,
        SUM(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
            OVER (PARTITION BY pro.pro_product_id) / 
            NULLIF(DATEDIFF(MONTH, MIN(CAST(od.od_order_date AS DATETIME)), MAX(CAST(od.od_order_date AS DATETIME))) + 1, 0) AS Average_Monthly_Revenue
    FROM gold.sales_orders od
    JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
    JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
    GROUP BY pro.pro_product_name, pro.pro_product_id
)
-- Consolidate the report
SELECT 
    pm.Product_Name, 
    pm.Category, 
    pm.Cost, 
    pm.Total_Orders, 
    pm.Total_Sales, 
    pm.Quantity_Sold, 
    pm.Unique_Customers, 
    pm.Life_Span_Months, 
    pm.Revenue_Segment,
    k.Recency_Months, 
    k.Average_Order_Revenue AS AOR, 
    k.Average_Monthly_Revenue
FROM ProductMetrics pm
LEFT JOIN KPIs k ON pm.Product_Name = k.Product_Name
ORDER BY pm.Total_Sales DESC;
