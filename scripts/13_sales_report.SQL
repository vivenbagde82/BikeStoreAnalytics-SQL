/*
===============================================================================
Sales Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Essential Fields:
        - Includes Customer Name, Age, and transactional dta (Total Orders, Total Sales, etc.).
    2. Customer Segmentation:
        - Categorizes customers ito VIP, Regular, and NEw based on spending.
    3. KPIs:
        - Recency: Months since the last order.
        - Average Order Value (AOV): Revenue per order.
        - Average Monthly Spend: Total sales divided by lifespan in months.
    4. Sorting:
        - Ordered by Total Sales to prioritize the most valuable customers.

===============================================================================
*/

-- Sales Report Query
WITH CustomerMetrics AS (
    -- Aggregate key customer-level metrics
    SELECT 
        cst.cst_firstname + ' ' + cst.cst_lastname AS Customer_Name,
        SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Sales,
        COUNT(DISTINCT od.od_order_id) AS Total_Orders,
        SUM(oi.od_it_quantity) AS Total_Quantity_Purchased,
        COUNT(DISTINCT oi.od_it_product_id) AS Total_Products,
        DATEDIFF(MONTH, MIN(CAST(od.od_order_date AS DATETIME)), MAX(CAST(od.od_order_date AS DATETIME))) + 1 AS Life_Span_Months,
        CASE 
            WHEN SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) >= 5000 THEN 'VIP'
            WHEN SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) BETWEEN 1000 AND 4999 THEN 'Regular'
            ELSE 'New'
        END AS Customer_Category
    FROM gold.sales_orders od
    JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
    JOIN gold.sales_customer cst ON od.od_customer_id = cst.cst_customer_id
    GROUP BY cst.cst_firstname, cst.cst_lastname
),
KPIs AS (
    -- Calculate valuable KPIs such as recency, average order value (AOV), and average monthly spend
    SELECT 
        cst.cst_firstname + ' ' + cst.cst_lastname AS Customer_Name,
        MAX(DATEDIFF(MONTH, CAST(od.od_order_date AS DATETIME), GETDATE())) AS Recency_Months,
        AVG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
            OVER (PARTITION BY cst.cst_customer_id) AS Average_Order_Value,
        SUM(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
            OVER (PARTITION BY cst.cst_customer_id) / 
            NULLIF(DATEDIFF(MONTH, MIN(CAST(od.od_order_date AS DATETIME)), MAX(CAST(od.od_order_date AS DATETIME))) + 1, 0) AS Average_Monthly_Spend
    FROM gold.sales_orders od
    JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
    JOIN gold.sales_customer cst ON od.od_customer_id = cst.cst_customer_id
    GROUP BY cst.cst_firstname, cst.cst_lastname, cst.cst_customer_id
)
-- Consolidate the report
SELECT 
    cm.Customer_Name, 
    cm.Total_Sales, 
    cm.Total_Orders, 
    cm.Total_Quantity_Purchased, 
    cm.Total_Products, 
    cm.Life_Span_Months, 
    cm.Customer_Category, 
    k.Recency_Months, 
    k.Average_Order_Value AS AOV, 
    k.Average_Monthly_Spend
FROM CustomerMetrics cm
LEFT JOIN KPIs k ON cm.Customer_Name = k.Customer_Name
ORDER BY cm.Total_Sales DESC;
