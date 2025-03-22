/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Total Number of Customers
SELECT 
    COUNT(*) AS Total_Customers 
FROM gold.sales_customer;

-- Total and Average Sales Quantity
SELECT 
    SUM(od_it_quantity) AS Total_Sales_Quantity, 
    AVG(od_it_quantity) AS Average_Sales_Quantity 
FROM gold.sales_order_items;

-- Total Revenue and Average List Price
SELECT 
    SUM(od_it_quantity * od_it_list_price * (1 - od_it_discount)) AS Total_Revenue, 
    AVG(od_it_list_price) AS Average_List_Price 
FROM gold.sales_order_items;

-- Active vs. Inactive staff Count
SELECT 
    SUM(CASE WHEN stf_active = 1 THEN 1 ELSE 0 END) AS Active_Staff_Count, 
    SUM(CASE WHEN stf_active = 0 THEN 1 ELSE 0 END) AS Inactive_Staff_Count 
FROM gold.sales_staffs;

-- Total Stores by City
SELECT 
    sto_city, 
    COUNT(*) AS Total_Stores 
FROM gold.sales_stores 
GROUP BY sto_city;

-- Average Discount Offered
SELECT 
    100.0*AVG(od_it_discount) AS Average_Discount 
FROM gold.sales_order_items;

-- Product Trends: Total Stock and Average Price by Category
SELECT 
    cat.cat_category_name, 
    SUM(sto.sto_quantity) AS Total_Stock, 
    AVG(pro.pro_list_price) AS Average_Price 
FROM gold.production_products pro
JOIN gold.production_categories cat ON pro.pro_category_id = cat.cat_category_id
JOIN gold.production_stocks sto ON pro.pro_product_id = sto.sto_product_id
GROUP BY cat.cat_category_name;

-- Total Orders and Revenue by Month (Temporal Trend)
SELECT 
    FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM') AS Order_Month, 
    COUNT(*) AS Total_Orders, 
    SUM(od_it_quantity * od_it_list_price * (1 - od_it_discount)) AS Total_Revenue
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
GROUP BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM')
ORDER BY Order_Month;
