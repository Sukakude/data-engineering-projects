CREATE SCHEMA IF NOT EXISTS dev;
CREATE TABLE IF NOT EXISTS dev.weather (
  id SERIAL PRIMARY KEY,
  city TEXT,
  temperature FLOAT,
  weather_descriptions TEXT,
  wind_speed FLOAT,
  time TIMESTAMP,
  inserted_at TIMESTAMP DEFAULT NOW(),
  utc_offset TEXT
);
