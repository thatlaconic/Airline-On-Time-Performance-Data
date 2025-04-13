{{
    config(
        materialized='table'
    )
}}

SELECT 
    Year,
    Month,
    AVG(ArrDelay) AS avg_delay,
    COUNT(*) AS flight_count
FROM {{ref("flights_2020-2021")}}
GROUP BY Year, Month
ORDER BY Year, Month