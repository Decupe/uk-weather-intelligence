CREATE OR ALTER VIEW vw_weather_readings AS
SELECT
    CAST(city_name           AS NVARCHAR(100)) AS city_name,
    CAST(country             AS NVARCHAR(10))  AS country,
    CAST(latitude            AS FLOAT)         AS latitude,
    CAST(longitude           AS FLOAT)         AS longitude,
    CAST(reading_timestamp   AS DATETIME2)     AS reading_timestamp,
    CAST(reading_date        AS DATE)          AS reading_date,
    CAST(reading_hour        AS INT)           AS reading_hour,
    CAST(weather_main        AS NVARCHAR(50))  AS weather_main,
    CAST(weather_description AS NVARCHAR(100)) AS weather_description,
    CAST(weather_severity    AS NVARCHAR(50))  AS weather_severity,
    CAST(comfort_level       AS NVARCHAR(50))  AS comfort_level,
    CAST(temperature_c       AS FLOAT)         AS temperature_c,
    CAST(feels_like_c        AS FLOAT)         AS feels_like_c,
    CAST(temp_min_c          AS FLOAT)         AS temp_min_c,
    CAST(temp_max_c          AS FLOAT)         AS temp_max_c,
    CAST(pressure_hpa        AS INT)           AS pressure_hpa,
    CAST(humidity_pct        AS INT)           AS humidity_pct,
    CAST(wind_speed_ms       AS FLOAT)         AS wind_speed_ms,
    CAST(wind_beaufort       AS INT)           AS wind_beaufort,
    CAST(cloud_cover_pct     AS INT)           AS cloud_cover_pct,
    CAST(rain_1h_mm          AS FLOAT)         AS rain_1h_mm,
    CAST(is_daytime          AS INT)           AS is_daytime,
    CAST(ingestion_date      AS DATE)          AS ingestion_date
FROM OPENROWSET(
    BULK 'https://ukweatherstorage.dfs.core.windows.net/silver/weather_readings/',
    FORMAT = 'DELTA'
) AS weather;
