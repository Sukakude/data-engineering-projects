

with source as (
    SELECT * 
    FROM "db"."dev"."weather"
),

-- REMOVE ANY DUPLICATES IN THE DATABASE
de_dup as (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY time ORDER BY inserted_at) as rn
    FROM source 
)

SELECT 
    id, 
    city, 
    temperature, 
    weather_descriptions, 
    wind_speed, 
    time as weather_time_local,
    (inserted_at + (utc_offset || 'hours')::interval) as inserted_at_local
FROM de_dup
WHERE rn = 1