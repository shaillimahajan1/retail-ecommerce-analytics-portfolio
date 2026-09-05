# Progress Log

## Day 5 
Built first Power BI dashboard (Superstore-style KPIs on Olist data) Total 
Revenue, Order Count, AOV, connected directly to Postgres instead of CSV. 
Found that filtering revenue/order count to "delivered" status only worked 
for measures I explicitly rewrote with CALCULATE() a duplicate, unfiltered 
measure (total_order_count) sat right next to a correctly filtered one 
(Delivered Order Count) with different values, and I mistook them for the 
same thing under two names. Learned to check the actual DAX formula bar 
directly rather than assuming an edit was saved.


## Day 4 
Loaded Olist CSVs into Pandas, converted date columns from string to datetime. 
Hit two separate bugs: (1) wrong date format silently nulled out most valid 
dates caught by comparing null counts before/after conversion, (2) after 
fixing the format, a downstream variable still held stale/broken data due to 
notebook execution order, not the code itself. Learned to verify data state 
at each step, not just trust that a fix upstream propagates automatically. 
Calculated average delivery time (12.09 days) as a sanity-checked final metric.

## Day 3 
Built running totals (per-category and overall) and revenue share % per 
category using SUM() OVER(). Found that removing PARTITION BY alone doesn't 
give a true "overall" running total if the underlying data is still grouped 
by category and month had to re-aggregate to month-only grain first. 
Learned that window functions operate on the grain you give them, not the 
grain you intend.

## Day 2 
Built a customer cohort/retention query. Found that the dataset has two 
customer ID columns customer_id (per-order) vs customer_unique_id (real 
identity) and using the wrong one would've made every customer look like 
a one-time buyer. Fixed by joining on customer_id but aggregating on 
customer_unique_id. Used AGE() + window functions to calculate months-since-
first-order, wrapped in a multi-layer CTE.

## Day 1 
Built a top-10-products-per-category query with month-over-month growth, 
using RANK() and LAG(). Found that LAG() compares to the previous row, not 
the previous calendar month a category with a zero-order month silently 
breaks the growth calculation. Documented as a known limitation.
