{{
    config(
        materialized='table'
    )
}}

SELECT 
    order_date, 
    SUM(total_amount) as daily_revenue 
FROM {{source('dev', 'raw_orders')}} 
GROUP BY order_date 
ORDER BY order_date ASC

