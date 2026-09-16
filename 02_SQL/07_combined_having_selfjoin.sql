WITH product_avg_price AS (
    -- Same as before: one row per product, its category, and average price
    SELECT p.product_id, t.product_category_name_english, AVG(oi.price) AS avg_price
    FROM olist_order_items_dataset AS oi
    JOIN olist_products_dataset AS p ON oi.product_id = p.product_id
    JOIN product_category_name_translation AS t ON p.product_category_name = t.product_category_name
    GROUP BY t.product_category_name_english, p.product_id
),
high_price_categories AS (
    -- Which categories qualify as "high average price"?
    -- Think: group product_avg_price by category, average the avg_price,
    -- and HAVING > 150 — same logic as Task 1, but now built ON TOP of
    -- product_avg_price instead of the raw tables directly
    SELECT product_category_name_english
    FROM product_avg_price
    GROUP BY product_category_name_english
    HAVING AVG(avg_price) > 150
)
-- Final query: your Task 2 self-join, but restricted to only categories
-- that appear in high_price_categories
SELECT pa1.product_category_name_english,
       pa1.product_id AS product_1_id, pa1.avg_price AS avg_price_1,
       pa2.product_id AS product_2_id, pa2.avg_price AS avg_price_2
FROM product_avg_price AS pa1
JOIN product_avg_price AS pa2
    ON pa1.product_category_name_english = pa2.product_category_name_english
    AND pa1.product_id < pa2.product_id
    AND ABS(pa1.avg_price - pa2.avg_price) < 5
WHERE pa1.product_category_name_english IN (
    SELECT product_category_name_english FROM high_price_categories
);