/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or stores over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

-- Year-over-Year Revenue Growth by Product
SELECT 
    pro.pro_product_name AS Product, 
    YEAR(CAST(od_order_date AS DATETIME)) AS Order_Year, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Revenue,
    LAG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER (PARTITION BY pro.pro_product_name ORDER BY YEAR(CAST(od_order_date AS DATETIME))) AS Previous_Year_Revenue,
    CASE 
        WHEN LAG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
            OVER (PARTITION BY pro.pro_product_name ORDER BY YEAR(CAST(od_order_date AS DATETIME))) IS NOT NULL THEN
            ROUND(100.0 * 
                (SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) -
                 LAG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
                    OVER (PARTITION BY pro.pro_product_name ORDER BY YEAR(CAST(od_order_date AS DATETIME)))) /
                 LAG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
                    OVER (PARTITION BY pro.pro_product_name ORDER BY YEAR(CAST(od_order_date AS DATETIME))), 2)
        ELSE NULL
    END AS YoY_Growth_Percentage
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
GROUP BY pro.pro_product_name, YEAR(CAST(od_order_date AS DATETIME))
ORDER BY Product, Order_Year;

-- Month-over-Month Customer Growth
SELECT 
    FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM') AS Order_Month, 
    COUNT(DISTINCT od.od_customer_id) AS Total_Customers,
    LAG(COUNT(DISTINCT od.od_customer_id)) 
        OVER (ORDER BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM')) AS Previous_Month_Customers,
    CASE 
        WHEN LAG(COUNT(DISTINCT od.od_customer_id)) 
            OVER (ORDER BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM')) IS NOT NULL THEN
            ROUND(100.0 * 
                (COUNT(DISTINCT od.od_customer_id) - 
                 LAG(COUNT(DISTINCT od.od_customer_id)) 
                    OVER (ORDER BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM'))) /
                 LAG(COUNT(DISTINCT od.od_customer_id)) 
                    OVER (ORDER BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM')), 2)
        ELSE NULL
    END AS MoM_Customer_Growth_Percentage
FROM gold.sales_orders od
GROUP BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM')
ORDER BY Order_Month;

-- Monthly Sales Performace with Moving Average
SELECT 
    FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM') AS Order_Month, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Monthly_Revenue,
    AVG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER (ORDER BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Moving_Average_Revenue
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
GROUP BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM')
ORDER BY Order_Month;

-- Top Performing Products YoY
SELECT 
    pro.pro_product_name AS Product, 
    YEAR(CAST(od_order_date AS DATETIME)) AS Order_Year, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Revenue,
    RANK() OVER (PARTITION BY YEAR(CAST(od_order_date AS DATETIME)) ORDER BY SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) DESC) AS Product_Rank
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
GROUP BY pro.pro_product_name, YEAR(CAST(od_order_date AS DATETIME))
ORDER BY Order_Year, Product_Rank;

-- Identify High Performing Customers (YoY Growth)
SELECT 
    cst.cst_firstname + ' ' + cst.cst_lastname AS Customer, 
    YEAR(CAST(od_order_date AS DATETIME)) AS Order_Year, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Spent,
    LAG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER (PARTITION BY cst.cst_customer_id ORDER BY YEAR(CAST(od_order_date AS DATETIME))) AS Previous_Year_Spent,
    CASE 
        WHEN LAG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
            OVER (PARTITION BY cst.cst_customer_id ORDER BY YEAR(CAST(od_order_date AS DATETIME))) IS NOT NULL THEN
            ROUND(100.0 * 
                (SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) -
                 LAG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
                    OVER (PARTITION BY cst.cst_customer_id ORDER BY YEAR(CAST(od_order_date AS DATETIME)))) /
                 LAG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
                    OVER (PARTITION BY cst.cst_customer_id ORDER BY YEAR(CAST(od_order_date AS DATETIME))), 2)
        ELSE NULL
    END AS YoY_Growth_Percentage
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
JOIN gold.sales_customer cst ON od.od_customer_id = cst.cst_customer_id
GROUP BY cst.cst_firstname, cst.cst_lastname, cst.cst_customer_id, YEAR(CAST(od_order_date AS DATETIME))
ORDER BY Customer, Order_Year;

