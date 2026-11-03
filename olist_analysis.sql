-- Olist E-Commerce Sales Analytics (SQLite)
-- Tables: orders, order_items, products, customers, order_reviews, product_category_name_translation

-- 1. Base dataset: delivered orders, Jan 2017 - Aug 2018
CREATE VIEW IF NOT EXISTS base AS
SELECT o.order_id,
       substr(o.order_purchase_timestamp,1,7) AS month,
       c.customer_state AS state,
       COALESCE(t.product_category_name_english,'unknown') AS category,
       i.price,
       CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END AS late,
       r.review_score
FROM orders o
JOIN order_items i ON i.order_id = o.order_id
JOIN products p    ON p.product_id = i.product_id
LEFT JOIN product_category_name_translation t ON t.product_category_name = p.product_category_name
JOIN customers c   ON c.customer_id = o.customer_id
LEFT JOIN (SELECT order_id, AVG(review_score) AS review_score FROM order_reviews GROUP BY order_id) r
       ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND substr(o.order_purchase_timestamp,1,7) BETWEEN '2017-01' AND '2018-08';

-- 2. Headline KPIs
SELECT ROUND(SUM(price)) AS revenue, COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(price)/COUNT(DISTINCT order_id),1) AS avg_order_value
FROM base;

-- 3. Monthly revenue
SELECT month, ROUND(SUM(price)) AS revenue FROM base GROUP BY month ORDER BY month;

-- 4. Year-over-year growth, Jan-Aug
SELECT SUM(CASE WHEN month BETWEEN '2017-01' AND '2017-08' THEN price END) AS rev_2017,
       SUM(CASE WHEN month BETWEEN '2018-01' AND '2018-08' THEN price END) AS rev_2018
FROM base;

-- 5. Top categories and revenue share
SELECT category, ROUND(SUM(price)) AS revenue,
       ROUND(100.0*SUM(price)/(SELECT SUM(price) FROM base),1) AS share_pct
FROM base GROUP BY category ORDER BY revenue DESC LIMIT 10;

-- 6. Revenue share by state
SELECT state, ROUND(100.0*SUM(price)/(SELECT SUM(price) FROM base),1) AS share_pct
FROM base GROUP BY state ORDER BY share_pct DESC;

-- 7. Late delivery rate and review score impact
SELECT late, COUNT(*) AS orders, ROUND(AVG(review_score),2) AS avg_review
FROM (SELECT order_id, MAX(late) AS late, AVG(review_score) AS review_score FROM base GROUP BY order_id)
GROUP BY late;
