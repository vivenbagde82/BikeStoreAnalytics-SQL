/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

-- Customer Segmentation by Spending
SELECT 
    cst.cst_firstname + ' ' + cst.cst_lastname AS Customer, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Spent,
    CASE 
        WHEN SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) < 1000 THEN 'Low Spender'
        WHEN SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) BETWEEN 1000 AND 5000 THEN 'Medium Spender'
        ELSE 'High Spender'
    END AS Spending_Segment
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
JOIN gold.sales_customer cst ON od.od_customer_id = cst.cst_customer_id
GROUP BY cst.cst_firstname, cst.cst_lastname;

-- Product Categorization by Price Range
SELECT 
    pro.pro_product_name AS Product, 
    pro.pro_list_price AS List_Price,
    CASE 
        WHEN pro.pro_list_price < 50 THEN 'Budget'
        WHEN pro.pro_list_price BETWEEN 50 AND 200 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS Price_Category
FROM gold.production_products pro;

-- Store Region Analysis
SELECT 
    sto.sto_store_name AS Store, 
    sto.sto_city AS City, 
    sto.sto_state AS State,
    CASE 
        WHEN sto.sto_state IN ('CA', 'NV', 'AZ') THEN 'Western Region'
        WHEN sto.sto_state IN ('TX', 'OK', 'NM') THEN 'Southern Region'
        WHEN sto.sto_state IN ('NY', 'PA', 'NJ') THEN 'Eastern Region'
        ELSE 'Other Region'
    END AS Region
FROM gold.sales_stores sto;

-- Order Value Segmentation
SELECT 
    od.od_order_id AS Order_ID, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Order_Value,
    CASE 
        WHEN SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) < 500 THEN 'Small Order'
        WHEN SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) BETWEEN 500 AND 2000 THEN 'Medium Order'
        ELSE 'Large Order'
    END AS Order_Segment
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
GROUP BY od.od_order_id;

-- Product Stock Segmentation by Availabiity
SELECT 
    pro.pro_product_name AS Product, 
    sto.sto_quantity AS Stock_Quantity,
    CASE 
        WHEN sto.sto_quantity = 0 THEN 'Out of Stock'
        WHEN sto.sto_quantity BETWEEN 1 AND 50 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS Stock_Status
FROM gold.production_stocks sto
JOIN gold.production_products pro ON sto.sto_product_id = pro.pro_product_id;

-- Customer Region Segmentation
SELECT 
    cst.cst_firstname + ' ' + cst.cst_lastname AS Customer, 
    cst.cst_city AS City, 
    cst.cst_state AS State,
    CASE 
        WHEN cst.cst_state IN ('CA', 'NV', 'AZ') THEN 'Western Region'
        WHEN cst.cst_state IN ('TX', 'OK', 'NM') THEN 'Southern Region'
        WHEN cst.cst_state IN ('NY', 'PA', 'NJ') THEN 'Eastern Region'
        ELSE 'Other Region'
    END AS Region
FROM gold.sales_customer cst;
