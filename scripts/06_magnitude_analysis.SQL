/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- Total and Average Sales by Product Category
SELECT 
    cat.cat_category_name AS Category, 
    SUM(od_it_quantity * od_it_list_price * (1 - od_it_discount)) AS Total_Sales_Revenue,
    AVG(od_it_quantity * od_it_list_price * (1 - od_it_discount)) AS Average_Sales_Revenue
FROM gold.sales_order_items oi
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
JOIN gold.production_categories cat ON pro.pro_category_id = cat.cat_category_id
GROUP BY cat.cat_category_name
ORDER BY Total_Sales_Revenue DESC;

-- Number of Orders and Average Revenue by Store
SELECT 
    sto.sto_store_name AS Store, 
    COUNT(od.od_order_id) AS Total_Orders, 
    AVG(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Average_Revenue_Per_Order
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
JOIN gold.sales_stores sto ON od.od_store_id = sto.sto_store_id
GROUP BY sto.sto_store_name
ORDER BY Total_Orders DESC;

-- Customer Distribution by City and State
SELECT 
    cst_city AS City, 
    cst_state AS State, 
    COUNT(*) AS Total_Customers
FROM gold.sales_customer
GROUP BY cst_city, cst_state
ORDER BY Total_Customers DESC;

-- Product Stock Distribution by Brand
SELECT 
    br.br_brand_name AS Brand, 
    SUM(sto.sto_quantity) AS Total_Stock
FROM gold.production_stocks sto
JOIN gold.production_products pro ON sto.sto_product_id = pro.pro_product_id
JOIN gold.production_brands br ON pro.pro_brand_id = br.br_brand_id
GROUP BY br.br_brand_name
ORDER BY Total_Stock DESC;

-- Staff Activity Analysis by Store
SELECT 
    sto.sto_store_name AS Store, 
    SUM(CASE WHEN stf.stf_active = 1 THEN 1 ELSE 0 END) AS Active_Staff,
    SUM(CASE WHEN stf.stf_active = 0 THEN 1 ELSE 0 END) AS Inactive_Staff
FROM gold.sales_staffs stf
JOIN gold.sales_stores sto ON stf.stf_store_id = sto.sto_store_id
GROUP BY sto.sto_store_name
ORDER BY Active_Staff DESC;

-- Order Distribution by Status
SELECT 
    od_order_status AS Order_Status, 
    COUNT(*) AS Total_Orders
FROM gold.sales_orders
GROUP BY od_order_status
ORDER BY Total_Orders DESC;

-- Top Products by Sales Quantity
SELECT 
    pro.pro_product_name AS Product, 
    SUM(oi.od_it_quantity) AS Total_Sales_Quantity
FROM gold.sales_order_items oi
JOIN gold.production_products pro ON oi.od_it_product_id = pro.pro_product_id
GROUP BY pro.pro_product_name
ORDER BY Total_Sales_Quantity DESC;
