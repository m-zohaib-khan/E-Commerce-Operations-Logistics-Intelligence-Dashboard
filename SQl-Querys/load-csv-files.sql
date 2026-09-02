-- ============================================================
-- LOAD CLEAN OLIST CSV FILES
-- ============================================================

-- 1. CUSTOMERS
LOAD DATA LOCAL INFILE 'D:/Financial-Dashboard-project/clean-data/customers.csv'
INTO TABLE clean_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 2. GEOLOCATION
LOAD DATA LOCAL INFILE 'D:/Financial-Dashboard-project/clean-data/geolocation.csv'
INTO TABLE clean_geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 3. ORDERS
LOAD DATA LOCAL INFILE 'D:/Financial-Dashboard-project/clean-data/data_clean_orders.csv'
INTO TABLE clean_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 4. ORDER ITEMS
LOAD DATA LOCAL INFILE 'D:/Financial-Dashboard-project/clean-data/order_items.csv'
INTO TABLE clean_order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 5. ORDER PAYMENTS
LOAD DATA LOCAL INFILE 'D:/Financial-Dashboard-project/clean-data/order_payments.csv'
INTO TABLE clean_order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 6. ORDER REVIEWS
LOAD DATA LOCAL INFILE 'D:/Financial-Dashboard-project/clean-data/order_reviews.csv'
INTO TABLE clean_order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 7. PRODUCTS
LOAD DATA LOCAL INFILE 'D:/Financial-Dashboard-project/clean-data/products.csv'
INTO TABLE clean_products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- 8. SELLERS
LOAD DATA LOCAL INFILE 'D:/Financial-Dashboard-project/clean-data/sellers.csv'
INTO TABLE clean_sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



-- 9. CATEGORY TRANSLATION
LOAD DATA LOCAL INFILE 'D:/Financial-Dashboard-project/clean-data/category_translation.csv'
INTO TABLE clean_category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



-- Verfiy that everything is loaded: -->  (there is some rows in some tables which are not loaded because of large amount of data):

SELECT 'clean_customers' AS table_name, COUNT(*) AS row_count
FROM clean_customers

UNION ALL

SELECT 'clean_geolocation', COUNT(*)
FROM clean_geolocation

UNION ALL

SELECT 'clean_orders', COUNT(*)
FROM clean_orders

UNION ALL

SELECT 'clean_order_items', COUNT(*)
FROM clean_order_items

UNION ALL

SELECT 'clean_order_payments', COUNT(*)
FROM clean_order_payments

UNION ALL

SELECT 'clean_order_reviews', COUNT(*)
FROM clean_order_reviews

UNION ALL

SELECT 'clean_products', COUNT(*)
FROM clean_products

UNION ALL

SELECT 'clean_sellers', COUNT(*)
FROM clean_sellers

UNION ALL

SELECT 'clean_category_translation', COUNT(*)
FROM clean_category_translation;

select * from financial_dashboard.clean_category_translation;
