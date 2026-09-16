select customer_unique_id, 
case when sum(price + freight_value) >= 1000 then 'High'
     when sum(price + freight_value) between 300 and 1000 then 'Medium'
	 else 'Low'
end as spending_tier
from olist_customers_dataset as c
join olist_orders_dataset as o
on c.customer_id = o.customer_id
join olist_order_items_dataset as oi
on o.order_id = oi.order_id
group by customer_unique_id;

SELECT spending_tier, COUNT(*) 
FROM (select customer_unique_id, 
case when sum(price + freight_value) >= 1000 then 'High'
     when sum(price + freight_value) between 300 and 1000 then 'Medium'
	 else 'Low'
end as spending_tier
from olist_customers_dataset as c
join olist_orders_dataset as o
on c.customer_id = o.customer_id
join olist_order_items_dataset as oi
on o.order_id = oi.order_id
group by customer_unique_id) AS sub
GROUP BY spending_tier;