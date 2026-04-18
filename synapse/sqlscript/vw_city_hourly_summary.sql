CREATE OR ALTER VIEW vw_city_hourly_summary AS
SELECT
    CAST(city_name         AS NVARCHAR(100)) AS city_name,
    CAST(latitude          AS FLOAT)         AS latitude,
    CAST(longitude         AS FLOAT)         AS longitude,
    CAST(reading_date      AS DATE)          AS reading_date,
    CAST(reading_hour      AS INT)           AS reading_hour,
    CAST(avg_temp_c        AS FLOAT)         AS avg_temp_c,
    CAST(max_temp_c        AS FLOAT)         AS max_temp_c,
    CAST(min_temp_c        AS FLOAT)         AS min_temp_c,
    CAST(avg_humidity      AS FLOAT)         AS avg_humidity,
    CAST(avg_pressure      AS FLOAT)         AS avg_pressure,
    CAST(avg_wind_speed    AS FLOAT)         AS avg_wind_speed,
    CAST(max_wind_gust     AS FLOAT)         AS max_wind_gust,
    CAST(avg_cloud_cover   AS FLOAT)         AS avg_cloud_cover,
    CAST(weather_condition AS NVARCHAR(50))  AS weather_condition,
    CAST(severity          AS NVARCHAR(50))  AS severity,
    CAST(beaufort_scale    AS INT)           AS beaufort_scale,
    CAST(comfort_level     AS NVARCHAR(50))  AS comfort_level,
    CAST(ingestion_date    AS DATE)          AS ingestion_date
FROM OPENROWSET(
    BULK 'https://ukweatherstorage.dfs.core.windows.net/gold/city_hourly_summary/',
    FORMAT = 'DELTA'
) AS summary;
