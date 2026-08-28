# Progress Log

## Day 2 — [Date]
Built a customer cohort/retention query. Found that the dataset has two 
customer ID columns — customer_id (per-order) vs customer_unique_id (real 
identity) — and using the wrong one would've made every customer look like 
a one-time buyer. Fixed by joining on customer_id but aggregating on 
customer_unique_id. Used AGE() + window functions to calculate months-since-
first-order, wrapped in a multi-layer CTE.
→ Output: [02_cohort_retention_analysis.sql](sql/02_cohort_retention_analysis.sql)

## Day 1 — [Date]
Built a top-10-products-per-category query with month-over-month growth, 
using RANK() and LAG(). Found that LAG() compares to the previous row, not 
the previous calendar month — a category with a zero-order month silently 
breaks the growth calculation. Documented as a known limitation.
→ Output: [01_top_products_mom_growth.sql](sql/01_top_products_mom_growth.sql)
