CREATE OR ALTER VIEW vw_air_quality AS
SELECT
    CAST(latitude          AS FLOAT)        AS latitude,
    CAST(longitude         AS FLOAT)        AS longitude,
    CAST(reading_timestamp AS DATETIME2)    AS reading_timestamp,
    CAST(reading_date      AS DATE)         AS reading_date,
    CAST(reading_hour      AS INT)          AS reading_hour,
    CAST(aqi               AS INT)          AS aqi,
    CAST(aqi_label         AS NVARCHAR(50)) AS aqi_label,
    CAST(pm2_5             AS FLOAT)        AS pm2_5,
    CAST(pm10              AS FLOAT)        AS pm10,
    CAST(no2               AS FLOAT)        AS no2,
    CAST(o3                AS FLOAT)        AS o3,
    CAST(co                AS FLOAT)        AS co,
    CAST(pm2_5_who_status  AS NVARCHAR(20)) AS pm2_5_who_status,
    CAST(no2_who_status    AS NVARCHAR(20)) AS no2_who_status,
    CAST(ingestion_date    AS DATE)         AS ingestion_date
FROM OPENROWSET(
    BULK 'https://ukweatherstorage.dfs.core.windows.net/silver/air_quality_readings/',
    FORMAT = 'DELTA'
) AS airquality;
