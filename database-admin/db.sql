
1. Initial query 
SELECT o.order_id, o.quantity, p.product_name, c.customer_name
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_date >= '2024-01-01'
AND c.country = 'Wakanda'
ORDER BY o.order_date DESC;

Indexed query : 

CREATE INDEX idx_orders_order_date ON orders (order_date);

CREATE INDEX idx_customers_id_country ON customers (customer_id, country);

CREATE INDEX idx_orders_product_id ON orders (product_id);

CREATE INDEX idx_products_product_id ON products (product_id);

CREATE INDEX idx_orders_covering ON orders (order_id, quantity, product_id, customer_id);

ANALYZE TABLE orders;
ANALYZE TABLE products;
ANALYZE TABLE customers;


2. Query Optimization

SELECT o.order_id, o.quantity, p.product_name, c.customer_name 
FROM orders o 
JOIN products p ON o.product_id = p.product_id 
JOIN customers c ON o.customer_id = c.customer_id 
WHERE o.order_date >= '2023-01-01' 
AND p.category = 'Explosives' 
AND c.country = 'Wakanda' 
ORDER BY o.order_date DESC;


CREATE INDEX idx_orders_order_date ON orders (order_date);

CREATE INDEX idx_customers_id_country ON customers (customer_id, country);

CREATE INDEX idx_orders_product_id ON orders (product_id);

CREATE INDEX idx_products_product_id ON products (product_id);

CREATE INDEX idx_orders_covering ON orders (order_id, quantity, product_id, customer_id);

ANALYZE orders;
ANALYZE products;
ANALYZE customers;


SELECT o.order_id, o.quantity, p.product_name, c.customer_name
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_date BETWEEN '2023-01-01' AND '2023-12-31'
  AND p.category = 'Explosives'
  AND c.country = 'Wakanda'
ORDER BY o.order_date DESC
LIMIT 1000;

