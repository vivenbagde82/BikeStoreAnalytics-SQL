/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, orders, stores) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Rank Products by Total Sales
SELECT 
    pro.pro_product_name AS Product, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Sales_Revenue,
    RANK() OVER (ORDER BY SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) DESC) AS Product_Rank
FROM gold.sales_order_items oi
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
GROUP BY pro.pro_product_name
ORDER BY Product_Rank;

-- Rank Customers by Total Orders
SELECT 
    cst.cst_firstname + ' ' + cst.cst_lastname AS Customer, 
    COUNT(od.od_order_id) AS Total_Orders,
    DENSE_RANK() OVER (ORDER BY COUNT(od.od_order_id) DESC) AS Customer_Rank
FROM gold.sales_orders od
JOIN gold.sales_customer cst ON od.od_customer_id = cst.cst_customer_id
GROUP BY cst.cst_firstname, cst.cst_lastname
ORDER BY Customer_Rank;

-- Rank Brands by Total Revenue
SELECT 
    br.br_brand_name AS Brand, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) DESC) AS Revenue_Rank
FROM gold.sales_order_items oi
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
JOIN gold.production_brands br ON pro.pro_brand_id = br.br_brand_id
GROUP BY br.br_brand_name
ORDER BY Revenue_Rank;

-- Top 10 Customers by Total Revenue
SELECT TOP 10
    cst.cst_firstname + ' ' + cst.cst_lastname AS Customer, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Revenue
FROM gold.sales_orders od
JOIN gold.sales_customer cst ON od.od_customer_id = cst.cst_customer_id
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
GROUP BY cst.cst_firstname, cst.cst_lastname
ORDER BY Total_Revenue DESC;

-- Rank Stores by Average Sales
SELECT 
    sto.sto_store_name AS Store, 
    AVG(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Average_Sales_Revenue,
    RANK() OVER (ORDER BY AVG(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) DESC) AS Store_Rank
FROM gold.sales_order_items oi
JOIN gold.sales_orders od ON oi.od_it_order_id = od.od_order_id
JOIN gold.sales_stores sto ON od.od_store_id = sto.sto_store_id
GROUP BY sto.sto_store_name
ORDER BY Store_Rank;

-- Rank Categories by Total Stock
SELECT 
    cat.cat_category_name AS Category, 
    SUM(sto.sto_quantity) AS Total_Stock,
    DENSE_RANK() OVER (ORDER BY SUM(sto.sto_quantity) DESC) AS Stock_Rank
FROM gold.production_stocks sto
JOIN gold.production_products pro ON sto.sto_product_id = pro.pro_product_id
JOIN gold.production_categories cat ON pro.pro_category_id = cat.cat_category_id
GROUP BY cat.cat_category_name
ORDER BY Stock_Rank;

-- Top 5 Performing Products
SELECT TOP 5 
    pro.pro_product_name AS Product, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Sales_Revenue
FROM gold.sales_order_items oi
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
GROUP BY pro.pro_product_name
ORDER BY Total_Sales_Revenue DESC;

-- Bottom 5 Performing Products
SELECT TOP 5 
    pro.pro_product_name AS Product, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Sales_Revenue
FROM gold.sales_order_items oi
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
GROUP BY pro.pro_product_name
ORDER BY Total_Sales_Revenue ASC;
