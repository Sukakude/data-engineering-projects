

SELECT
    city,
    date(weather_time_local) as date,
    ROUND(AVG(temperature)::NUMERIC, 2) as avg_temperature,
    ROUND(AVG(wind_speed)::NUMERIC, 2) as avg_wind_speed
FROM "db"."dev"."stg_weather"
GROUP BY city, date(weather_time_local)
ORDER BY city, date(weather_time_local)