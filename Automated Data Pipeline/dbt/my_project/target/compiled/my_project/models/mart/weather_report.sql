-- THIS SCRIPT IS RESPONSIBLE FOR CREATING TABLES THAT WILL BE USED FOR REPORTING


SELECT 
    city,
    temperature,
    weather_descriptions,
    wind_speed,
    weather_time_local
FROM "db"."dev"."stg_weather"