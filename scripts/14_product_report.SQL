





WITH ProductMetrics AS (
    -- Calculate production metrics: total stock, average production cost, and categorize products
    SELECT 
        pro.pro_product_name AS Product, 
        cat.cat_category_name AS Category, 
        br.br_brand_name AS Brand,
        AVG(pro.pro_list_price) AS Average_Cost,
        SUM(sto.sto_quantity) AS Total_Stock,
        CASE 
            WHEN SUM(sto.sto_quantity) >= 1000 THEN 'High Stock'
            WHEN SUM(sto.sto_quantity) BETWEEN 500 AND 999 THEN 'Moderate Stock'
            ELSE 'Low Stock'
        END AS Stock_Segment
    FROM gold.production_products pro
    JOIN gold.production_categories cat ON pro.pro_category_id = cat.cat_category_id
    JOIN gold.production_brands br ON pro.pro_brand_id = br.br_brand_id
    JOIN gold.production_stocks sto ON pro.pro_product_id = sto.sto_product_id
    GROUP BY pro.pro_product_name, cat.cat_category_name, br.br_brand_name
),
KPIs AS (
    -- Calculate KPI metrics without relying on unavailable columns
    SELECT 
        pro.pro_product_name AS Product, 
        SUM(sto.sto_quantity) AS Total_Stock_Replenished,
        SUM(sto.sto_quantity) / NULLIF(COUNT(DISTINCT sto.sto_product_id), 0) AS Average_Monthly_Stock
    FROM gold.production_products pro
    JOIN gold.production_stocks sto ON pro.pro_product_id = sto.sto_product_id
    GROUP BY pro.pro_product_name
)
-- Consolidate the report
SELECT 
    pm.Product, 
    pm.Category, 
    pm.Brand, 
    pm.Average_Cost, 
    pm.Total_Stock, 
    pm.Stock_Segment,
    k.Total_Stock_Replenished AS Total_Replenishment,
    k.Average_Monthly_Stock AS Monthly_Stock
FROM ProductMetrics pm
LEFT JOIN KPIs k ON pm.Product = k.Product
ORDER BY pm.Total_Stock DESC;
