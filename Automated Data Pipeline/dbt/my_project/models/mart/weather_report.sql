-- THIS SCRIPT IS RESPONSIBLE FOR CREATING TABLES THAT WILL BE USED FOR REPORTING
{{
    config(
        materialized='table',
        unique_key='id'
    )
}}

SELECT 
    city,
    temperature,
    weather_descriptions,
    wind_speed,
    weather_time_local
FROM {{ ref('stg_weather') }}