
1. CREATE INDEX idx_orders_product_id_customer_id_order_date ON orders (product_id, customer_id, order_date);
CREATE INDEX idx_products_product_id ON products (product_id);
CREATE INDEX idx_customers_customer_id_country ON customers (customer_id, country);

SELECT o.order_id, o.quantity, p.product_name, c.customer_name
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_date >= '2024-01-01'
AND c.country = 'Wakanda'
ORDER BY o.order_date DESC;


2. 

