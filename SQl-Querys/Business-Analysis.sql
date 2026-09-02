-- Q1. What is total revenue?
SELECT
    ROUND(SUM(item_revenue), 2) AS total_revenue
FROM fact_sales;

-- Q2. What is total freight/shipment cost?
SELECT
    ROUND(SUM(freight_value), 2) AS total_freight
FROM fact_sales;



-- Q4. What are the monthly sales trends? 
SELECT

    d.year,

    d.month,


    d.month_name,

    ROUND(SUM(f.item_revenue), 2) AS revenue,

    COUNT(DISTINCT f.order_key) AS total_orders

FROM fact_sales f

JOIN dim_date d
    ON f.date_key = d.date_key

GROUP BY
    d.year,
    d.month,
    d.month_name

ORDER BY
    d.year,
    d.month;
    
    
-- Q5. Which product categories generate the most revenue?
SELECT

    p.product_category,

    ROUND(
        SUM(f.item_revenue),
        2
    ) AS revenue,

    COUNT(*) AS items_sold

FROM fact_sales f

JOIN dim_product p
    ON f.product_key = p.product_key

GROUP BY
    p.product_category

ORDER BY
    revenue DESC;
    
-- Q6. Top 10 products by revenue
SELECT

    p.product_id,

    p.product_category,

    ROUND(
        SUM(f.item_revenue),
        2
    ) AS revenue

FROM fact_sales f

JOIN dim_product p
    ON f.product_key = p.product_key

GROUP BY
    p.product_id,
    p.product_category

ORDER BY
    revenue DESC

LIMIT 10;


-- Q7. Which sellers generate the most revenue?
SELECT

    s.seller_id,

    s.seller_city,

    s.seller_state,

    ROUND(
        SUM(f.item_revenue),
        2
    ) AS revenue,

    COUNT(DISTINCT f.order_key) AS orders

FROM fact_sales f

JOIN dim_seller s
    ON f.seller_key = s.seller_key

GROUP BY

    s.seller_id,
    s.seller_city,
    s.seller_state

ORDER BY
    revenue DESC

LIMIT 10;


-- Q8. Which states generate the most revenue?
SELECT

    c.customer_state,

    ROUND(
        SUM(f.item_revenue),
        2
    ) AS revenue,

    COUNT(DISTINCT f.order_key) AS orders

FROM fact_sales f

JOIN dim_order o
    ON f.order_key = o.order_key

JOIN dim_customer c
    ON o.customer_key = c.customer_key

GROUP BY
    c.customer_state

ORDER BY
    revenue DESC;

-- Q9. What is the average order value?
SELECT

    ROUND(
        SUM(item_revenue)
        / COUNT(DISTINCT order_key),
        2
    ) AS average_order_value

FROM fact_sales;

-- Q10. What percentage of orders are late?
SELECT

    ROUND(
        SUM(is_late) /
        COUNT(*) * 100,
        2
    ) AS late_percentage

FROM dim_order;

-- Q11. Average delivery time
SELECT

    ROUND(
        AVG(delivery_days),
        2
    ) AS average_delivery_days

FROM dim_order

WHERE delivery_days IS NOT NULL;

-- Q13. Which payment method is most popular?
SELECT

    payment_type,

    COUNT(*) AS payment_count,

    ROUND(
        SUM(payment_value),
        2
    ) AS payment_value

FROM fact_payment

GROUP BY
    payment_type

ORDER BY
    payment_count DESC;


-- Q14. Which payment method generates the most payment value?
SELECT

    payment_type,

    ROUND(
        SUM(payment_value),
        2
    ) AS total_payment_value

FROM fact_payment

GROUP BY
    payment_type

ORDER BY
    total_payment_value DESC;
    
-- Q15. What is the average review score?
SELECT

    ROUND(
        AVG(review_score),
        2
    ) AS average_review_score

FROM fact_review;

-- Q16. Review score distribution
SELECT

    review_score,

    COUNT(*) AS review_count

FROM fact_review

GROUP BY
    review_score

ORDER BY
    review_score;
    
-- Q17. Does late delivery affect review scores?
SELECT

    o.is_late, # its means if the delivery is not late, the review is good, otherwise bad

    COUNT(r.review_key) AS reviews,

    ROUND(
        AVG(r.review_score),
        2
    ) AS average_review_score

FROM fact_review r

JOIN dim_order o
    ON r.order_key = o.order_key

GROUP BY
    o.is_late;

-- Q18. Top 10 customers by spending
SELECT

    c.customer_unique_id,

    c.customer_city,

    c.customer_state,

    ROUND(
        SUM(f.item_revenue),
        2
    ) AS total_spending

FROM fact_sales f

JOIN dim_order o
    ON f.order_key = o.order_key

JOIN dim_customer c
    ON o.customer_key = c.customer_key

GROUP BY

    c.customer_unique_id,
    c.customer_city,
    c.customer_state

ORDER BY
    total_spending DESC

LIMIT 10;

