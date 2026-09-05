# Retail & E-commerce Analytics Portfolio

Self-directed portfolio built while transitioning from BI/Infrastructure Analytics 
(3 years at TCS Oracle SQL, Power BI, DAX) into Retail & E-commerce Analytics. 
Each project uses real, publicly available e-commerce datasets and focuses on 
business questions a retail/e-commerce analyst would actually be asked to answer.

## Tools Used
- PostgreSQL (pgAdmin4) SQL: joins, CTEs, window functions (RANK, LAG, SUM OVER), 
  aggregate functions, date/time logic
- Python (Pandas) - data loading, cleaning, datetime handling, groupby/filtering
- Power BI — DAX (CALCULATE, DISTINCTCOUNT, DIVIDE), data modeling, direct 
  PostgreSQL connection, interactive dashboards
- Excel — formulas, pivot tables, percentage-based KPI calculations
- Dataset: [Olist Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## Projects

| # | Project | Business Question | Key Techniques | 
|---|---------|-------------------|-----------------|
| 1 | Top Products & Month-over-Month Growth | Which products drive the most revenue in each category, and how is category revenue trending month to month? | Multi-table joins, RANK() window function, LAG() for period-over-period growth, CTEs | 
| 2 | Customer Cohort & Retention Analysis | How many months after their first order do customers come back to buy again? | Window functions (MIN() OVER), AGE()-based date math, multi-layer CTEs, cohort aggregation | 
| 3 | Running Totals & Revenue Share | How does revenue accumulate over time, and what % of total revenue does each category represent? | SUM() OVER() (partitioned and unpartitioned), grain management, percentage-of-total calculations | 
| 4 | Delivery Time Analysis (Pandas) | How long does delivery take on average, and what data-cleaning was needed to get there reliably? | Pandas: CSV loading, datetime conversion, filtering, groupby, date arithmetic | 
| 5 | Retail KPI Dashboard (Power BI) | What's total revenue, order volume, and AOV — and how does revenue trend month over month, by category? | Power BI, DAX (CALCULATE, DISTINCTCOUNT, DIVIDE), direct Postgres connection, year slicer | 
| 6 | Sell-Through Rate Calculator | Which products/categories are overstocked or understocked, and does a category-level average hide problem products? | Excel formulas, pivot tables, percentage KPI calculation |

## Notable Data-Quality Findings

While building these, I ran into real data-quality issues worth documenting
these reflect the kind of validation work a BI/data analyst does daily:

- **Duplicate customer identity columns:** The dataset has both `customer_id` 
  (generated per order) and `customer_unique_id` (the actual persistent customer). 
  Using the wrong one silently makes every customer look like a one-time buyer, 
  with no query error to flag it.
- **LAG() and non-contiguous time series:** `LAG()` compares to the previous *row*, 
  not the previous *calendar period* a category with a zero-order month causes 
  month-over-month growth to be silently miscalculated. Noted as a limitation; 
  a full fix would use `generate_series()` to build a complete calendar spine.
- **Window functions don't fix grain problems:** Removing `PARTITION BY` to get 
  an "overall" running total doesn't work if the underlying data is still grouped 
  by a dimension (like category) you meant to collapse the base query's grain 
  has to be corrected first.
- **Silent date-parsing failures in Pandas:** Converting string dates to datetime 
  with the wrong `format=` string caused `errors='coerce'` to silently null out 
  most valid dates instead of erroring caught by comparing null counts before 
  and after conversion.
- **Incomplete final-year data:** The dataset only contains orders through 
  August 2018. A month-over-month trend chart spanning all years showed a 
  sharp apparent "drop" near year-end this wasn't a real decline, it was 
  caused by missing 2018 data being blended with complete years (2016/2017) 
  in the same chart. Verified by adding a year slicer and checking years separately.
- **Category averages can mask outlier products:** A category-level average 
  sell-through rate (e.g., 73% for Beauty) can hide individual products 
  performing far below or above that average (e.g., a 30% sell-through 
  product within the same category) — aggregates are a starting point for 
  investigation, not a final answer.

## About Me

BI/Data Analyst with 3 years of experience in Oracle SQL, Power BI, and DAX, 
currently building deep expertise in retail/e-commerce analytics. 
