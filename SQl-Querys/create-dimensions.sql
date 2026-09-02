-- ============================================================
-- OLIST E-COMMERCE ANALYTICS PROJECT (FULLY OPTIMIZED)
-- ============================================================

USE financial_dashboard;

-- Drop old DIMENSION and FACT tables
DROP TABLE IF EXISTS fact_review;
DROP TABLE IF EXISTS fact_payment;
DROP TABLE IF EXISTS fact_sales;

DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_order;
DROP TABLE IF EXISTS dim_seller;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_customer;

-- ============================================================
-- 0. STAGING INDEXES (FOR INSTANT JOIN LOOKUPS)
-- ============================================================
CREATE INDEX idx_cc_cust_id ON clean_customers(customer_id);
CREATE INDEX idx_cp_prod_id ON clean_products(product_id);
CREATE INDEX idx_cs_sell_id ON clean_sellers(seller_id);
CREATE INDEX idx_co_ord_id ON clean_orders(order_id);
CREATE INDEX idx_coi_fk ON clean_order_items(order_id, product_id, seller_id);
CREATE INDEX idx_cop_ord_id ON clean_order_payments(order_id);
CREATE INDEX idx_cor_ord_id ON clean_order_reviews(order_id);

-- ============================================================
-- 1. DIM CUSTOMER
-- ============================================================
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50) UNIQUE NOT NULL,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(5)
);

INSERT INTO dim_customer (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM clean_customers
WHERE customer_id IS NOT NULL
ON DUPLICATE KEY UPDATE
    customer_unique_id = VALUES(customer_unique_id),
    customer_zip_code_prefix = VALUES(customer_zip_code_prefix),
    customer_city = VALUES(customer_city),
    customer_state = VALUES(customer_state);

-- ============================================================
-- 2. DIM PRODUCT
-- ============================================================
CREATE TABLE IF NOT EXISTS dim_product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(50) UNIQUE NOT NULL,
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(10,2),
    product_length_cm DECIMAL(10,2),
    product_height_cm DECIMAL(10,2),
    product_width_cm DECIMAL(10,2),
    product_category VARCHAR(100)
);

INSERT INTO dim_product (
    product_id,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    product_category
)
SELECT
    product_id,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    product_category
FROM clean_products
WHERE product_id IS NOT NULL
ON DUPLICATE KEY UPDATE
    product_category = VALUES(product_category),
    product_name_length = VALUES(product_name_length),
    product_description_length = VALUES(product_description_length),
    product_photos_qty = VALUES(product_photos_qty),
    product_weight_g = VALUES(product_weight_g),
    product_length_cm = VALUES(product_length_cm),
    product_height_cm = VALUES(product_height_cm),
    product_width_cm = VALUES(product_width_cm);

-- ============================================================
-- 3. DIM SELLER
-- ============================================================
CREATE TABLE IF NOT EXISTS dim_seller (
    seller_key INT AUTO_INCREMENT PRIMARY KEY,
    seller_id VARCHAR(50) UNIQUE NOT NULL,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(5)
);

INSERT INTO dim_seller (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM clean_sellers
WHERE seller_id IS NOT NULL
ON DUPLICATE KEY UPDATE
    seller_zip_code_prefix = VALUES(seller_zip_code_prefix),
    seller_city = VALUES(seller_city),
    seller_state = VALUES(seller_state);

-- ============================================================
-- 4. DIM ORDER
-- ============================================================
CREATE TABLE IF NOT EXISTS dim_order (
    order_key INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50) UNIQUE NOT NULL,
    customer_key INT,
    order_status VARCHAR(30),
    purchase_timestamp DATETIME,
    approved_at DATETIME,
    delivered_carrier_date DATETIME,
    delivered_customer_date DATETIME,
    estimated_delivery_date DATETIME,
    delivery_days DECIMAL(10,2),
    is_late TINYINT,
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key)
);

INSERT INTO dim_order (
    order_id,
    customer_key,
    order_status,
    purchase_timestamp,
    approved_at,
    delivered_carrier_date,
    delivered_customer_date,
    estimated_delivery_date,
    delivery_days,
    is_late
)
SELECT
    o.order_id,
    c.customer_key,
    o.order_status,
    CASE WHEN o.order_purchase_timestamp LIKE '0000%' THEN NULL ELSE o.order_purchase_timestamp END,
    CASE WHEN o.order_approved_at LIKE '0000%' THEN NULL ELSE o.order_approved_at END,
    CASE WHEN o.order_delivered_carrier_date LIKE '0000%' THEN NULL ELSE o.order_delivered_carrier_date END,
    CASE WHEN o.order_delivered_customer_date LIKE '0000%' THEN NULL ELSE o.order_delivered_customer_date END,
    CASE WHEN o.order_estimated_delivery_date LIKE '0000%' THEN NULL ELSE o.order_estimated_delivery_date END,
    o.delivery_days,
    o.is_late
FROM clean_orders o
INNER JOIN dim_customer c
    ON o.customer_id = c.customer_id
WHERE o.order_id IS NOT NULL
ON DUPLICATE KEY UPDATE
    customer_key = VALUES(customer_key),
    order_status = VALUES(order_status),
    purchase_timestamp = VALUES(purchase_timestamp),
    approved_at = VALUES(approved_at),
    delivered_carrier_date = VALUES(delivered_carrier_date),
    delivered_customer_date = VALUES(delivered_customer_date),
    estimated_delivery_date = VALUES(estimated_delivery_date),
    delivery_days = VALUES(delivery_days),
    is_late = VALUES(is_late);

-- Index created on dim_order to speed up fact table loading
CREATE INDEX idx_do_lookup ON dim_order(order_id, order_key, purchase_timestamp);

-- ============================================================
-- 5. DIM DATE
-- ============================================================
CREATE TABLE IF NOT EXISTS dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE UNIQUE NOT NULL,
    year INT,
    quarter INT,
    month INT,
    month_name VARCHAR(20),
    day INT,
    day_name VARCHAR(20),
    day_of_week INT
);

INSERT INTO dim_date (
    date_key,
    full_date,
    year,
    quarter,
    month,
    month_name,
    day,
    day_name,
    day_of_week
)
SELECT DISTINCT
    CAST(DATE_FORMAT(DATE(order_purchase_timestamp), '%Y%m%d') AS UNSIGNED) AS date_key,
    DATE(order_purchase_timestamp) AS full_date,
    YEAR(order_purchase_timestamp) AS year,
    QUARTER(order_purchase_timestamp) AS quarter,
    MONTH(order_purchase_timestamp) AS month,
    MONTHNAME(order_purchase_timestamp) AS month_name,
    DAY(order_purchase_timestamp) AS day,
    DAYNAME(order_purchase_timestamp) AS day_name,
    DAYOFWEEK(order_purchase_timestamp) AS day_of_week
FROM clean_orders
WHERE order_purchase_timestamp IS NOT NULL 
  AND order_purchase_timestamp NOT LIKE '0000%'
ON DUPLICATE KEY UPDATE
    full_date = VALUES(full_date),
    year = VALUES(year),
    quarter = VALUES(quarter),
    month = VALUES(month),
    month_name = VALUES(month_name),
    day = VALUES(day),
    day_name = VALUES(day_name),
    day_of_week = VALUES(day_of_week);

-- ============================================================
-- 6. FACT SALES
-- ============================================================
CREATE TABLE IF NOT EXISTS fact_sales (
    sales_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_key INT NOT NULL,
    product_key INT NOT NULL,
    seller_key INT NOT NULL,
    date_key INT NOT NULL,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    item_revenue DECIMAL(10,2),
    FOREIGN KEY (order_key) REFERENCES dim_order(order_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (seller_key) REFERENCES dim_seller(seller_key),
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

-- OPTIMIZED: Direct integer key lookup instead of full-table DATE() conversion scans
INSERT INTO fact_sales (
    order_key,
    product_key,
    seller_key,
    date_key,
    price,
    freight_value,
    item_revenue
)
SELECT
    o.order_key,
    p.product_key,
    s.seller_key,
    CAST(DATE_FORMAT(o.purchase_timestamp, '%Y%m%d') AS UNSIGNED) AS date_key,
    i.price,
    i.freight_value,
    (i.price + i.freight_value) AS item_revenue
FROM clean_order_items i
INNER JOIN dim_order o
    ON i.order_id = o.order_id
INNER JOIN dim_product p
    ON i.product_id = p.product_id
INNER JOIN dim_seller s
    ON i.seller_id = s.seller_id
WHERE o.purchase_timestamp IS NOT NULL;

-- ============================================================
-- 7. FACT PAYMENT
-- ============================================================
CREATE TABLE IF NOT EXISTS fact_payment (
    payment_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_key INT NOT NULL,
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    FOREIGN KEY (order_key) REFERENCES dim_order(order_key)
);

INSERT INTO fact_payment (
    order_key,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    o.order_key,
    p.payment_sequential,
    p.payment_type,
    p.payment_installments,
    p.payment_value
FROM clean_order_payments p
INNER JOIN dim_order o
    ON p.order_id = o.order_id;

-- ============================================================
-- 8. FACT REVIEW
-- ============================================================
CREATE TABLE IF NOT EXISTS fact_review (
    review_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_key INT NOT NULL,
    review_id VARCHAR(50),
    review_score INT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,
    FOREIGN KEY (order_key) REFERENCES dim_order(order_key)
);

INSERT INTO fact_review (
    order_key,
    review_id,
    review_score,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    o.order_key,
    r.review_id,
    r.review_score,
    CASE WHEN r.review_creation_date LIKE '0000%' THEN NULL ELSE r.review_creation_date END,
    CASE WHEN r.review_answer_timestamp LIKE '0000%' THEN NULL ELSE r.review_answer_timestamp END
FROM clean_order_reviews r
INNER JOIN dim_order o
    ON r.order_id = o.order_id;

-- ============================================================
-- 9. VERIFY TABLES & ROW COUNTS
-- ============================================================
SHOW TABLES;

SELECT 'dim_customer' AS table_name, COUNT(*) AS row_count FROM dim_customer
UNION ALL
SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL
SELECT 'dim_seller', COUNT(*) FROM dim_seller
UNION ALL
SELECT 'dim_order', COUNT(*) FROM dim_order
UNION ALL
SELECT 'dim_date', COUNT(*) FROM dim_date
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM fact_sales
UNION ALL
SELECT 'fact_payment', COUNT(*) FROM fact_payment
UNION ALL
SELECT 'fact_review', COUNT(*) FROM fact_review;


select * from financial_dashboard.fact_review;
