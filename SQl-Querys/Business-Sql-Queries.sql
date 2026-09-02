USE financial_dashboard;

-- ══════════════════════════════════════════════
-- QUERY 1: Overall Business Summary
-- ══════════════════════════════════════════════
SELECT
    COUNT(DISTINCT s.order_key)         AS total_orders,
    ROUND(SUM(s.price), 2)              AS total_revenue,
    ROUND(SUM(s.freight_value), 2)      AS total_freight_cost,
    ROUND(SUM(s.item_revenue), 2)       AS total_gross_revenue,
    ROUND(AVG(s.price), 2)              AS avg_item_price
FROM fact_sales s;


-- ══════════════════════════════════════════════
-- QUERY 2: Revenue & Gross Volume by Category
-- (The core insight query)
-- ══════════════════════════════════════════════
SELECT
    p.product_category                             AS category,
    COUNT(DISTINCT s.order_key)                    AS total_orders,
    ROUND(SUM(s.price), 2)                         AS total_product_revenue,
    ROUND(SUM(s.freight_value), 2)                 AS total_freight,
    ROUND(SUM(s.item_revenue), 2)                  AS total_gross_revenue,
    RANK() OVER (ORDER BY SUM(s.price) DESC)       AS revenue_rank,
    RANK() OVER (ORDER BY SUM(s.item_revenue) DESC) AS gross_revenue_rank
FROM fact_sales s
JOIN dim_product p ON s.product_key = p.product_key
GROUP BY p.product_category
ORDER BY total_gross_revenue DESC;


-- ══════════════════════════════════════════════
-- QUERY 3: Monthly Revenue Trend + MoM Growth
-- ══════════════════════════════════════════════
WITH monthly AS (
    SELECT
        d.year                                    AS order_year,
        d.month                                   AS order_month,
        ROUND(SUM(s.price), 2)                    AS revenue,
        ROUND(SUM(s.item_revenue), 2)             AS gross_revenue
    FROM fact_sales s
    JOIN dim_date d ON s.date_key = d.date_key
    GROUP BY d.year, d.month
)
SELECT
    order_year,
    order_month,
    revenue,
    gross_revenue,
    LAG(revenue) OVER (ORDER BY order_year, order_month) AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY order_year, order_month))
        / LAG(revenue) OVER (ORDER BY order_year, order_month) * 100
    , 2) AS mom_growth_pct
FROM monthly
ORDER BY order_year, order_month;


-- ══════════════════════════════════════════════
-- QUERY 4: Regional Sales & Delivery Performance
-- ══════════════════════════════════════════════
SELECT
    c.customer_state                    AS region,
    COUNT(DISTINCT s.order_key)         AS total_orders,
    ROUND(SUM(s.price), 2)              AS total_revenue,
    ROUND(SUM(s.freight_value), 2)      AS total_freight,
    ROUND(AVG(o.delivery_days), 1)      AS avg_delivery_days
FROM fact_sales s
JOIN dim_order o ON s.order_key = o.order_key
JOIN dim_customer c ON o.customer_key = c.customer_key
GROUP BY c.customer_state
ORDER BY total_revenue DESC;


-- ══════════════════════════════════════════════
-- QUERY 5: Day of Week Performance
-- ══════════════════════════════════════════════
SELECT
    d.day_name                          AS order_dayofweek,
    COUNT(DISTINCT s.order_key)         AS total_orders,
    ROUND(SUM(s.price), 2)              AS total_product_revenue,
    ROUND(SUM(s.item_revenue), 2)       AS total_gross_revenue
FROM fact_sales s
JOIN dim_date d ON s.date_key = d.date_key
GROUP BY d.day_name, d.day_of_week
ORDER BY d.day_of_week ASC;
