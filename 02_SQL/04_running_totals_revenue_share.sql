-- ==========================================================================================
-- Micro-project 3: Running Totals + Category Revenue Share
-- Dataset: Olist Brazilian E-Commerce
-- ==========================================================================================

-- Query 1: Running total according to category
SELECT 
    c.product_category_name_english,
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
    SUM(oi.price + oi.freight_value) AS total_revenue_per_category,
    SUM(SUM(oi.price + oi.freight_value)) OVER (
        PARTITION BY c.product_category_name_english
        ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
    ) AS running_total
FROM olist_orders_dataset AS o
JOIN olist_order_items_dataset AS oi ON o.order_id = oi.order_id
JOIN olist_products_dataset AS p ON oi.product_id = p.product_id
JOIN product_category_name_translation AS c ON p.product_category_name = c.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY c.product_category_name_english, DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY c.product_category_name_english, DATE_TRUNC('month', o.order_purchase_timestamp);


-- Query 2: Overall running total no category partition

SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
    SUM(oi.price + oi.freight_value) AS total_monthly_revenue,
    SUM(SUM(oi.price + oi.freight_value)) OVER (
        ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
    ) AS running_total
FROM olist_orders_dataset AS o
JOIN olist_order_items_dataset AS oi ON o.order_id = oi.order_id
JOIN olist_products_dataset AS p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp);

-- Query 3: Revenue Share (%) per category

SELECT 
c.product_category_name_english,
SUM(oi.price + oi.freight_value) AS total_revenue_per_category,
sum(SUM(oi.price + oi.freight_value)) over () as grand_total_revenue,
round((SUM(oi.price + oi.freight_value) / SUM(SUM(oi.price + oi.freight_value)) over ()*100):: numeric, 2) as revenue_share_pct
from olist_orders_dataset AS o
JOIN olist_order_items_dataset AS oi ON o.order_id = oi.order_id
JOIN olist_products_dataset AS p ON oi.product_id = p.product_id
JOIN product_category_name_translation AS c ON p.product_category_name = c.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY c.product_category_name_english
ORDER BY c.product_category_name_english;


------------------------------------------------------------------------------------------------------

SELECT SUM(revenue_share_pct) FROM (
 SELECT 
c.product_category_name_english,
SUM(oi.price + oi.freight_value) AS total_revenue_per_category,
sum(SUM(oi.price + oi.freight_value)) over () as grand_total_revenue,
round((SUM(oi.price + oi.freight_value) / SUM(SUM(oi.price + oi.freight_value)) over ()*100):: numeric, 2) as revenue_share_pct
from olist_orders_dataset AS o
JOIN olist_order_items_dataset AS oi ON o.order_id = oi.order_id
JOIN olist_products_dataset AS p ON oi.product_id = p.product_id
JOIN product_category_name_translation AS c ON p.product_category_name = c.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY c.product_category_name_english
ORDER BY c.product_category_name_english
) AS sub;
