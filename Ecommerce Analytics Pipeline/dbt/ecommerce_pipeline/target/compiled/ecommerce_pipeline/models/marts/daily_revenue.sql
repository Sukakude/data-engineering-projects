

SELECT 
    order_date, 
    SUM(total_amount) as daily_revenue 
FROM "ecommerce_db"."dev"."raw_orders" 
GROUP BY order_date 
ORDER BY order_date ASC