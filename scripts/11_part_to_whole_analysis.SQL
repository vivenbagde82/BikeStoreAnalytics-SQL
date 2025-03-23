/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

-- Revenue Contribution by Product Category
SELECT 
    cat.cat_category_name AS Category, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Category_Revenue,
    SUM(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER () AS Total_Revenue,
    ROUND(100.0 * SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) 
        / SUM(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER (), 2) AS Percentage_Contribution
FROM gold.sales_order_items oi
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
JOIN gold.production_categories cat ON pro.pro_category_id = cat.cat_category_id
GROUP BY cat.cat_category_name;

-- Customer Contribution to Total Orders by Region
SELECT 
    cst.cst_city AS City, 
    cst.cst_state AS State, 
    COUNT(od.od_order_id) AS Orders_By_Region,
    SUM(COUNT(od.od_order_id)) OVER () AS Total_Orders,
    ROUND(100.0 * COUNT(od.od_order_id) 
        / SUM(COUNT(od.od_order_id)) OVER (), 2) AS Percentage_Contribution
FROM gold.sales_orders od
JOIN gold.sales_customer cst ON od.od_customer_id = cst.cst_customer_id
GROUP BY cst.cst_city, cst.cst_state;

-- Top Performing Products as Part of Total Revenue
SELECT 
    pro.pro_product_name AS Product, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Product_Revenue,
    SUM(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER () AS Total_Revenue,
    ROUND(100.0 * SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) 
        / SUM(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER (), 2) AS Percentage_Contribution
FROM gold.sales_order_items oi
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
GROUP BY pro.pro_product_name
ORDER BY Product_Revenue DESC;

-- Regional Revenue Analysis (Part-to-Whole Comparison)
SELECT 
    sto.sto_city AS City, 
    sto.sto_state AS State, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Regional_Revenue,
    SUM(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER () AS Total_Revenue,
    ROUND(100.0 * SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) 
        / SUM(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER (), 2) AS Percentage_Contribution
FROM gold.sales_order_items oi
JOIN gold.sales_orders od ON oi.od_it_order_id = od.od_order_id
JOIN gold.sales_stores sto ON od.od_store_id = sto.sto_store_id
GROUP BY sto.sto_city, sto.sto_state
ORDER BY Regional_Revenue DESC;

-- Product Category Contribution Over Time (Yearly Analysis)
SELECT 
    cat.cat_category_name AS Category, 
    YEAR(CAST(od_order_date AS DATETIME)) AS Order_Year, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Category_Revenue,
    SUM(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER (PARTITION BY YEAR(CAST(od_order_date AS DATETIME))) AS Total_Revenue_By_Year,
    ROUND(100.0 * SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) 
        / SUM(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER (PARTITION BY YEAR(CAST(od_order_date AS DATETIME))), 2) AS Percentage_Contribution
FROM gold.sales_order_items oi
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
JOIN gold.production_categories cat ON pro.pro_category_id = cat.cat_category_id
JOIN gold.sales_orders od ON oi.od_it_order_id = od.od_order_id
GROUP BY cat.cat_category_name, YEAR(CAST(od_order_date AS DATETIME))
ORDER BY Order_Year, Percentage_Contribution DESC;

-- A/B Testing: Comparing Revenue Between Two Categories
SELECT 
    cat.cat_category_name AS Category, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Category_Revenue,
    CASE 
        WHEN cat.cat_category_name IN ('Category A', 'Category B') THEN 'Test Group'
        ELSE 'Control Group'
    END AS Group_Type
FROM gold.sales_order_items oi
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
JOIN gold.production_categories cat ON pro.pro_category_id = cat.cat_category_id
GROUP BY cat.cat_category_name, 
         CASE 
             WHEN cat.cat_category_name IN ('Category A', 'Category B') THEN 'Test Group'
             ELSE 'Control Group'
         END;

