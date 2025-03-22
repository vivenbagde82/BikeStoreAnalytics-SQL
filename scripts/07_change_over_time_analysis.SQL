/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Monthly Order Trends (seasonality)
SELECT 
    FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM') AS Order_Month, 
    COUNT(od_order_id) AS Total_Orders, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Revenue
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
GROUP BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM')
ORDER BY Order_Month;

-- Yearly Growth in Revenue
SELECT 
    DATEPART(YEAR, CAST(od_order_date AS DATETIME)) AS Order_Year, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Total_Revenue,
    LAG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER (ORDER BY DATEPART(YEAR, CAST(od_order_date AS DATETIME))) AS Previous_Year_Revenue,
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) -
    LAG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
        OVER (ORDER BY DATEPART(YEAR, CAST(od_order_date AS DATETIME))) AS Revenue_Growth
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
GROUP BY DATEPART(YEAR, CAST(od_order_date AS DATETIME))
ORDER BY Order_Year;

-- Quarterly Average Revenue
SELECT 
    CONCAT('Q', DATEPART(QUARTER, CAST(od_order_date AS DATETIME)), ' ', DATEPART(YEAR, CAST(od_order_date AS DATETIME))) AS Quarter,
    AVG(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Average_Quarterly_Revenue
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
GROUP BY 
    DATEPART(YEAR, CAST(od_order_date AS DATETIME)), 
    DATEPART(QUARTER, CAST(od_order_date AS DATETIME))
ORDER BY Quarter;

--Seasonal Trend in Order Counts
SELECT 
    DATEPART(MONTH, CAST(od_order_date AS DATETIME)) AS Order_Month, 
    COUNT(od_order_id) AS Total_Orders
FROM gold.sales_orders
GROUP BY DATEPART(MONTH, CAST(od_order_date AS DATETIME))
ORDER BY Order_Month;

-- Revenue Comparisons Across Years
SELECT 
    DATEPART(YEAR, CAST(od_order_date AS DATETIME)) AS Year, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Revenue,
    ROUND(100.0 * (SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) - 
    LAG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
    OVER (ORDER BY DATEPART(YEAR, CAST(od_order_date AS DATETIME)))) / 
    LAG(SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount))) 
    OVER (ORDER BY DATEPART(YEAR, CAST(od_order_date AS DATETIME))), 2) AS Growth_Percentage
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
GROUP BY DATEPART(YEAR, CAST(od_order_date AS DATETIME))
ORDER BY Year;

-- Weekly Revenue Trend
SELECT 
    DATETRUNC(WEEK, CAST(od_order_date AS DATETIME)) AS Week_Start_Date, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Weekly_Revenue
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
GROUP BY DATETRUNC(WEEK, CAST(od_order_date AS DATETIME))
ORDER BY Week_Start_Date;

-- Orders Placed by Day of the Week
SELECT 
    DATEPART(WEEKDAY, CAST(od_order_date AS DATETIME)) AS Day_of_Week, 
    COUNT(*) AS Total_Orders
FROM gold.sales_orders
GROUP BY DATEPART(WEEKDAY, CAST(od_order_date AS DATETIME))
ORDER BY Day_of_Week;

-- Compare Peak Months for Sales
SELECT 
    FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM') AS Order_Month, 
    SUM(oi.od_it_quantity * oi.od_it_list_price * (1 - oi.od_it_discount)) AS Monthly_Revenue
FROM gold.sales_orders od
JOIN gold.sales_order_items oi ON od.od_order_id = oi.od_it_order_id
GROUP BY FORMAT(CAST(od_order_date AS DATETIME), 'yyyy-MM')
ORDER BY Monthly_Revenue DESC;
