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
===============================================================================
*/

-- Cumulative Revenue Over Time
SELECT 
    FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM') AS Order_Month, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Monthly_Revenue,
    SUM(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER (ORDER BY MIN(CAST(od_order_date AS DATETIME))) AS Cumulative_Revenue
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
GROUP BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM')
ORDER BY Order_Month;

-- Cumulative Order Count
SELECT 
    FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM') AS Order_Month, 
    COUNT(od_order_id) AS Monthly_Order_Count,
    SUM(COUNT(od_order_id)) OVER (ORDER BY MIN(CAST(od_order_date AS DATETIME))) AS Cumulative_Order_Count
FROM gold.sales_orders
GROUP BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM')
ORDER BY Order_Month;

-- Moving Average of Revenue Over 3 Months
SELECT 
    FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM') AS Order_Month, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Monthly_Revenue,
    AVG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER (ORDER BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM') 
              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Moving_Average_Revenue
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
GROUP BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM')
ORDER BY Order_Month;

-- Cumulative Sales Quantity for Products
SELECT 
    pro.pro_product_name AS Product, 
    SUM(oi.od_it_quantity) AS Total_Sales_Quantity,
    SUM(SUM(oi.od_it_quantity)) OVER (ORDER BY pro.pro_product_name) AS Cumulative_Sales_Quantity
FROM gold.sales_order_items oi
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
GROUP BY pro.pro_product_name
ORDER BY Product;

-- Cumulative Active Customers Over Time
WITH MonthlyCustomerData AS (
    SELECT 
        CAST(DATEFROMPARTS(YEAR(CAST(od_order_date AS DATETIME)), MONTH(CAST(od_order_date AS DATETIME)), 1) AS DATE) AS Order_Month, 
        COUNT(DISTINCT od.od_customer_id) AS Monthly_New_Customers
    FROM gold.sales_orders od
    GROUP BY 
        YEAR(CAST(od_order_date AS DATETIME)), 
        MONTH(CAST(od_order_date AS DATETIME))
)
SELECT 
    Order_Month, 
    Monthly_New_Customers,
    SUM(Monthly_New_Customers) OVER (ORDER BY Order_Month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_Customers
FROM MonthlyCustomerData
ORDER BY Order_Month;

-- Revenue Growth with Moving Average
WITH MonthlyRevenue AS (
    SELECT 
        CAST(DATEFROMPARTS(YEAR(CAST(od_order_date AS DATETIME)), MONTH(CAST(od_order_date AS DATETIME)), 1) AS DATE) AS Order_Month, 
        SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Monthly_Revenue
    FROM gold.sales_orders od
    JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
    GROUP BY 
        YEAR(CAST(od_order_date AS DATETIME)), 
        MONTH(CAST(od_order_date AS DATETIME))
)
SELECT 
    Order_Month, 
    Monthly_Revenue,
    SUM(Monthly_Revenue) OVER (ORDER BY Order_Month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_Revenue,
    AVG(Monthly_Revenue) OVER (ORDER BY Order_Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Moving_Average_Revenue
FROM MonthlyRevenue
ORDER BY Order_Month;

-- Cumulative Stock Count by Category
SELECT 
    cat.cat_category_name AS Category, 
    SUM(sto.sto_quantity) AS Total_Stock,
    SUM(SUM(sto.sto_quantity)) OVER (ORDER BY cat.cat_category_name) AS Cumulative_Stock
FROM gold.production_stocks sto
JOIN gold.production_products pro ON sto.sto_product_id = pro.pro_product_id
JOIN gold.production_categories cat ON pro.pro_category_id = cat.cat_category_id
GROUP BY cat.cat_category_name
ORDER BY Category;
