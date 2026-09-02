-- ============================================================
-- OLIST E-COMMERCE ANALYTICS PROJECT
-- CREATE DATABASE AND CLEAN/STAGING TABLES
-- ============================================================

-- PART 1 — CREATE DATABASE
CREATE DATABASE IF NOT EXISTS financial_dashboard;

USE financial_dashboard;


-- ============================================================
-- PART 2 — CUSTOMERS
-- ============================================================

CREATE TABLE IF NOT EXISTS clean_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(5)
);


-- ============================================================
-- PART 3 — GEOLOCATION
-- ============================================================

CREATE TABLE IF NOT EXISTS clean_geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10,6),
    geolocation_lng DECIMAL(10,6),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(5)
);


-- ============================================================
-- PART 4 — ORDERS
-- ============================================================

CREATE TABLE IF NOT EXISTS clean_orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(30),

    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,

    delivery_days DECIMAL(10,2),
    is_late TINYINT,

    order_year INT,
    order_month INT,
    order_month_name VARCHAR(20),
    order_quarter INT,
    order_dayofweek VARCHAR(20)
);


-- ============================================================
-- PART 5 — ORDER ITEMS
-- ============================================================

CREATE TABLE IF NOT EXISTS clean_order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),

    shipping_limit_date DATETIME,

    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);


-- ============================================================
-- PART 6 — PAYMENTS
-- ============================================================

CREATE TABLE IF NOT EXISTS clean_order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);


-- ============================================================
-- PART 7 — REVIEWS
-- ============================================================

CREATE TABLE IF NOT EXISTS clean_order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),

    review_score INT,

    review_comment_title TEXT,
    review_comment_message TEXT,

    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);


-- ============================================================
-- PART 8 — PRODUCTS
-- ============================================================

CREATE TABLE IF NOT EXISTS clean_products (

    product_id VARCHAR(50) PRIMARY KEY,
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,

    product_weight_g DECIMAL(10,2),
    product_length_cm DECIMAL(10,2),
    product_height_cm DECIMAL(10,2),
    product_width_cm DECIMAL(10,2),
	product_category VARCHAR(100)

);


-- ============================================================
-- PART 9 — SELLERS
-- ============================================================

CREATE TABLE IF NOT EXISTS clean_sellers (

    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(5)
);

-- PART 8 — CATEGORY TRANSLATION
-- If you already removed the Portuguese category from clean_products, this table is mainly your reference/source table.

CREATE TABLE  IF NOT EXISTS clean_category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);


-- ============================================================
-- PART 10 — VERIFY TABLES
-- ============================================================

SHOW TABLES;

