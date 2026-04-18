CREATE OR ALTER VIEW vw_temperature_predictions AS
SELECT
    CAST(city_name          AS NVARCHAR(100)) AS city_name,
    CAST(reading_timestamp  AS DATETIME2)     AS reading_timestamp,
    CAST(reading_date       AS DATE)          AS reading_date,
    CAST(actual_temp_c      AS FLOAT)         AS actual_temp_c,
    CAST(predicted_temp_24h AS FLOAT)         AS predicted_temp_24h,
    CAST(actual_temp_24h    AS FLOAT)         AS actual_temp_24h,
    CAST(error_celsius      AS FLOAT)         AS error_celsius,
    CAST(model_name         AS NVARCHAR(100)) AS model_name,
    CAST(ingestion_date     AS DATE)          AS ingestion_date
FROM OPENROWSET(
    BULK 'https://ukweatherstorage.dfs.core.windows.net/gold/temperature_predictions/',
    FORMAT = 'DELTA'
) AS predictions;
