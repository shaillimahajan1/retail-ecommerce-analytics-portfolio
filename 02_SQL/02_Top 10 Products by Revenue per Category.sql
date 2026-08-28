-- ============================================
-- Micro-Project 1: Top 10 Products by Revenue per Category
-- + Month-over-Month Growth
-- Dataset: Olist Brazilian E-Commerce
-- ============================================

-- QUERY 1: Top 10 products by total revenue, ranked within each category
WITH ranked_products AS (
    SELECT 
        p.product_id, 
        c.product_category_name_english,  
        SUM(oi.price + oi.freight_value) AS total_revenue_per_category, 
        RANK() OVER (
            PARTITION BY c.product_category_name_english
            ORDER BY SUM(oi.price + oi.freight_value) DESC 
        ) AS category_rank
    FROM olist_orders_dataset AS o
    JOIN olist_order_items_dataset AS oi ON o.order_id = oi.order_id
    JOIN olist_products_dataset AS p ON oi.product_id = p.product_id
    JOIN product_category_name_translation AS c ON p.product_category_name = c.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY c.product_category_name_english, p.product_id
)
SELECT * 
FROM ranked_products
WHERE category_rank <= 10
ORDER BY product_category_name_english, category_rank;


-- QUERY 2: Month-over-Month revenue growth per category
-- NOTE (known limitation): LAG() compares to the previous ROW, not the
-- previous CALENDAR month. If a category has a month with zero orders,
-- that month is skipped entirely, and LAG() silently compares against
-- an earlier month instead. A full fix would require generating a
-- complete category x month calendar grid (e.g. via generate_series())
-- and LEFT JOINing actual revenue onto it before applying LAG().
SELECT 
    c.product_category_name_english, 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month, 
    LAG(SUM(oi.price + oi.freight_value)) OVER (
        PARTITION BY c.product_category_name_english
        ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
    ) AS previous_month,
    SUM(oi.price + oi.freight_value) AS total_revenue_per_category,
    ROUND(
        (
            (SUM(oi.price + oi.freight_value) 
             - LAG(SUM(oi.price + oi.freight_value)) OVER (
                    PARTITION BY c.product_category_name_english
                    ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
               )
            ) 
            / NULLIF(
                LAG(SUM(oi.price + oi.freight_value)) OVER (
                    PARTITION BY c.product_category_name_english
                    ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
                ), 0
              ) * 100
        )::numeric, 2
    ) AS mom_growth_pct
FROM olist_orders_dataset AS o
JOIN olist_order_items_dataset AS oi ON o.order_id = oi.order_id
JOIN olist_products_dataset AS p ON oi.product_id = p.product_id
JOIN product_category_name_translation AS c ON p.product_category_name = c.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY c.product_category_name_english, DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY c.product_category_name_english, DATE_TRUNC('month', o.order_purchase_timestamp);
