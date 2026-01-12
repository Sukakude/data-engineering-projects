
  
    

  create  table "db"."dev"."staging__dbt_tmp"
  
  
    as
  
  (
    

with source as (
    SELECT * 
    FROM "db"."dev"."weather"
)

SELECT 
    id, 
    city, 
    temperature, 
    weather_descriptions, 
    wind_speed, 
    time as weather_time_local,
    (inserted_at + (utc_offset || 'hours')::interval) as inserted_at_local
FROM source
  );
  