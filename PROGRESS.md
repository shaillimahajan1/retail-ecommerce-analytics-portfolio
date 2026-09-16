# Progress Log

## Day 1 
Built a top-10-products-per-category query with month-over-month growth, 
using RANK() and LAG(). Found that LAG() compares to the previous row, not 
the previous calendar month a category with a zero-order month silently 
breaks the growth calculation. Documented as a known limitation.

## Day 2 
Built a customer cohort/retention query. Found that the dataset has two 
customer ID columns customer_id (per-order) vs customer_unique_id (real 
identity) and using the wrong one would've made every customer look like 
a one-time buyer. Fixed by joining on customer_id but aggregating on 
customer_unique_id. Used AGE() + window functions to calculate months-since-
first-order, wrapped in a multi-layer CTE.

## Day 3 
Built running totals (per-category and overall) and revenue share % per 
category using SUM() OVER(). Found that removing PARTITION BY alone doesn't 
give a true "overall" running total if the underlying data is still grouped 
by category and month had to re-aggregate to month-only grain first. 
Learned that window functions operate on the grain you give them, not the 
grain you intend.

## Day 4 
Loaded Olist CSVs into Pandas, converted date columns from string to datetime. 
Hit two separate bugs: (1) wrong date format silently nulled out most valid 
dates caught by comparing null counts before/after conversion, (2) after 
fixing the format, a downstream variable still held stale/broken data due to 
notebook execution order, not the code itself. Learned to verify data state 
at each step, not just trust that a fix upstream propagates automatically. 
Calculated average delivery time (12.09 days) as a sanity-checked final metric.

## Day 5 
Built first Power BI dashboard (Superstore-style KPIs on Olist data) Total 
Revenue, Order Count, AOV, connected directly to Postgres instead of CSV. 
Found that filtering revenue/order count to "delivered" status only worked 
for measures I explicitly rewrote with CALCULATE() a duplicate, unfiltered 
measure (total_order_count) sat right next to a correctly filtered one 
(Delivered Order Count) with different values, and I mistook them for the 
same thing under two names. Learned to check the actual DAX formula bar 
directly rather than assuming an edit was saved.

## Day 6
Refreshed Excel fundamentals (formulas, fill-down, pivot tables) and studied 
retail KPI literacy AOV, CLV, cart abandonment, conversion rate, sell-through 
rate, gross margin. Built a sell-through rate calculator with a pivot table 
averaging rate by category. Found that category-level averages can mask 
problem products Beauty averaged 73% sell-through, but that hid a Hair Dryer 
sitting at just 30%, a real markdown/overstock candidate invisible at the 
aggregate level. Same "aggregate hides detail" lesson as Day 1's top-products 
work, showing up in a new tool.

## Day 7 Week 1 Complete 
Weekly retro + full mock interview. Retro covered all 6 days' concepts cold 
window functions (RANK/LAG/SUM OVER), CTEs and SQL execution order, the 
Pandas notebook-state bug, DAX filter context vs. CALCULATE(), and connecting 
retail KPIs to each other (not just defining them). Mock interview: 1 SQL 
live-coding question (second-highest-per-group pattern flagged for another 
pass next retro), 1 case-study question (revenue drop investigation needed 
scaffolding on structuring the approach, now have a reusable 4-stage 
framework: clarify → rule out data issues → decompose the metric → find 
cause → recommend action), 1 behavioral (customer_id/customer_unique_id 
story), 1 DAX conceptual (row context vs. filter context) both delivered 
cleanly, tied to real project examples.

Week 1 summary: 6 projects shipped (SQL x3, Pandas, Power BI dashboard, 
Excel), 6 real bugs/insights caught and documented, GitHub fully structured 
with README + progress log, retail KPI vocabulary internalized well enough 
to connect metrics to each other, not just define them in isolation.

## Day 8 
Started Tier 2 dropped structured courses in favor of task-first learning, 
since that's clearly how I learn fastest (confirmed after a full week of 
hands-on SQL work). Rebuilt Day 1's SQL revenue-per-category query in Pandas: 
merged 4 tables (orders, order_items, products, category translation), 
filtered to delivered orders, grouped and summed revenue, then visualized 
top 10 categories with matplotlib. Verified results matched the SQL version 
exactly (agro_industry_and_commerce: 76,203.30 in both). Hit two errors along 
the way a typo (`.merged` instead of `.merge`) and a column-naming 
mismatch after merging (`price` vs `price_x`) both fixed by directly 
inspecting `.columns.tolist()` instead of guessing.

## Day 9
Built customer spending-tier segmentation in SQL (CASE WHEN, no CTE needed 
confirmed aggregates can be wrapped in CASE WHEN directly within the same 
GROUP BY). Calculated mean/median/std of order value in Pandas; found mean 
(₹160.58) notably higher than median (₹105.29), correctly diagnosed as 
right-skewed distribution, tied back to a small number of high-value orders 
pulling the average up. Hit a serious data-cleaning bug: price and 
freight_value columns contained "$" symbols and comma thousand-separators 
as raw strings pd.to_numeric(errors='coerce') silently converted every 
value to NaN, then fillna(0) zeroed them all out, with no error thrown. 
Same "coerce hides silent damage" lesson as Day 4's datetime bug, now a 
confirmed pattern to watch for whenever converting string columns to 
numeric. Rebuilt the customer spending-tier segmentation in Pandas using 
merges + groupby, cross-validated tier counts against SQL (84,758/9,471/1,191 matched).

## Day 10
Learned HAVING (filtering on aggregate results, since WHERE can't reference 
values that don't exist until after GROUP BY) and self-joins (joining a 
table to itself to compare rows within it). Built a query finding 
closely-priced product pairs (within ₹5) in the same category using a 
self-join with a product_id < product_id condition solves both the 
self-matching and duplicate-mirrored-pair problems at once. Combined this 
with HAVING logic in a 3-CTE query to find closely-priced pairs only within 
categories whose average price exceeds ₹150, using a subquery with IN() 
to link the two conditions together. Verified output against the 
standalone Task 1 query.

