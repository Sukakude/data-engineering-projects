

SELECT 
    p.id as product_id, 
    p.title as product_name, 
    p.category as product_category, 
    p.rating as avg_product_rating, 
    SUM(o.total_amount) as total_revenue 
FROM 
    "ecommerce_db"."dev"."raw_products" p 
JOIN 
    "ecommerce_db"."dev"."raw_orders" o 
ON 
    p.id = o.product_id 
GROUP BY p.id
ORDER BY total_revenue DESC