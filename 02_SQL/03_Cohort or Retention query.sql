==========================================================================================
-- Micro-project 2: Cohort/Retention query
-- Dataset: Olist Brazilian E-Commerce
-- ===========================================================================================

-- Query 1: Find the first order month of each customer


/* SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'olist_customers_dataset'; 
used to find the name or  info related to the columns in a table*/

/* SELECT customer_unique_id, COUNT(*) 
FROM olist_customers_dataset 
GROUP BY customer_unique_id 
ORDER BY COUNT(*) DESC 
LIMIT 10;
used to see how many times a customer_unique_id is repeated */

select c.customer_unique_id, o.order_purchase_timestamp, 
MIN(DATE_TRUNC('month', o.order_purchase_timestamp)) 
OVER (PARTITION BY c.customer_unique_id) AS first_order_month,
(EXTRACT(YEAR FROM AGE(o.order_purchase_timestamp, MIN(DATE_TRUNC('month', o.order_purchase_timestamp)) 
OVER (PARTITION BY c.customer_unique_id))) * 12) + 
 EXTRACT(MONTH FROM AGE(o.order_purchase_timestamp, MIN(DATE_TRUNC('month', o.order_purchase_timestamp)) 
OVER (PARTITION BY c.customer_unique_id))) as difference
from olist_customers_dataset as c
join olist_orders_dataset as o
on c.customer_id = o.customer_id;

-- Query 1: total distinct customer_id (order-level, "fake" unique)
SELECT COUNT(DISTINCT customer_id) FROM olist_customers_dataset;

-- Query 2: total distinct customer_unique_id (real person-level)
SELECT COUNT(DISTINCT customer_unique_id) FROM olist_customers_dataset;

-- just a sanity check to differentiate between both the ids

----------------------------------------------
SELECT c.customer_unique_id, o.order_purchase_timestamp,
       MIN(DATE_TRUNC('month', o.order_purchase_timestamp)) 
           OVER (PARTITION BY c.customer_unique_id) AS first_order_month
FROM olist_customers_dataset AS c
JOIN olist_orders_dataset AS o ON c.customer_id = o.customer_id
WHERE c.customer_unique_id = '00172711b30d52eea8b313a7f2cced02'  -- use the FULL id, not truncated
ORDER BY o.order_purchase_timestamp;

-------------------------------------------------------
-- CTE

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp,
        MIN(DATE_TRUNC('month', o.order_purchase_timestamp)) 
            OVER (PARTITION BY c.customer_unique_id) AS first_order_month
    FROM olist_customers_dataset AS c
    JOIN olist_orders_dataset AS o
        ON c.customer_id = o.customer_id
),
customer_diffs AS (
    SELECT
        customer_unique_id,
        order_purchase_timestamp,
        first_order_month,
        (EXTRACT(YEAR FROM AGE(order_purchase_timestamp, first_order_month)) * 12)
            + EXTRACT(MONTH FROM AGE(order_purchase_timestamp, first_order_month)) AS difference
    FROM customer_orders
)
SELECT 
    first_order_month, 
    difference, 
    COUNT(DISTINCT customer_unique_id) AS num_customers
FROM customer_diffs
GROUP BY first_order_month, difference
ORDER BY first_order_month, difference;

/*SELECT *
FROM customer_diffs
WHERE customer_unique_id = '00172711b30d52eea8b313a7f2cced02'
ORDER BY order_purchase_timestamp; sanity check*/

------------------------------------------------------------------------------------
