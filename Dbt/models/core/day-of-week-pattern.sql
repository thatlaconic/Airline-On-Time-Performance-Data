{{
    config(
        materialized='table'
    )
}}

SELECT 
    Year,
    Month,
    DayOfWeek,
    AVG(ArrDelay) AS avg_delay,
    COUNT(*) AS flights
FROM {{ ref("flights_2020-2021")}}
GROUP BY Year, Month, DayOfWeek
ORDER BY Year, Month, DayOfWeek