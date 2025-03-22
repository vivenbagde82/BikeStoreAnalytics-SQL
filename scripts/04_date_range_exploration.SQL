/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Earliest and Latest Order Dates
SELECT 
    MIN(CAST(od_order_date AS DATETIME)) AS Earliest_Order_Date,
    MAX(CAST(od_order_date AS DATETIME)) AS Latest_Order_Date
FROM gold.sales_orders;

-- Order Date Range in Days
SELECT 
    DATEDIFF(
        DAY, 
        MIN(CAST(od_order_date AS DATETIME)), 
        MAX(CAST(od_order_date AS DATETIME))
    ) AS Order_Date_Range_Days
FROM gold.sales_orders;

-- Earliest and Latest Required Shipping Dates
SELECT 
    MIN(CAST(od_required_date AS DATETIME)) AS Earliest_Required_Date,
    MAX(CAST(od_required_date AS DATETIME)) AS Latest_Required_Date
FROM gold.sales_orders;


-- Product Lifespan by Model Year
SELECT 
    MIN(pro_model_year) AS Oldest_Model_Year,
    MAX(pro_model_year) AS Newest_Model_Year,
    MAX(pro_model_year) - MIN(pro_model_year) AS Model_Year_Range
FROM gold.production_products;
