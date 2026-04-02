{{
    config(
        materialized='table'
    )
}}

SELECT 
    c.id, 
    c.firstname, 
    c.lastname, 
    c.email, 
    c.phone, 
    COUNT(*) as total_orders, 
    CASE 
        WHEN COUNT(*) > 1 THEN 1 
        ELSE 0 
    END AS is_returning_customer 
FROM {{source('dev', 'raw_customers')}} c 
JOIN {{source('dev', 'raw_orders')}} o 
ON c.id = o.customer_id 
GROUP BY c.id