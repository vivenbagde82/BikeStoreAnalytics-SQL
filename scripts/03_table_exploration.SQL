/*
===============================================================================
Table Exploration
===============================================================================
Purpose:
    - To explore the structure of tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Distinct categories
SELECT DISTINCT cat_category_name
FROM gold.production_categories;

-- Distinct brands
SELECT DISTINCT br_brand_name
FROM gold.production_brands;

-- Distinct products by categories and brands
SELECT DISTINCT 
    pro.product_name, 
    br.br_brand_name, 
    cat.cat_category_name
FROM gold.production_products pro
JOIN gold.production_brands br ON pro.pro_brand_id = br.br_brand_id
JOIN gold.production_categories cat ON pro.pro_category_id = cat.cat_category_id;

-- Distinct stores, city and state
SELECT DISTINCT 
    sto_store_name, 
    sto_city, 
    sto_state 
FROM gold.sales_stores;

-- Distinct firstname, lastname, city and state
SELECT DISTINCT 
    cst_firstname, 
    cst_lastname, 
    cst_city, 
    cst_state 
FROM gold.sales_customer;

-- Distinct Order Statuses
SELECT DISTINCT od_order_status
FROM gold.sales_orders;
