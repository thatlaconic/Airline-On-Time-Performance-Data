{{
    config(
        materialized='table'
    )
}}

SELECT 
    Origin, 
    Dest,
    AVG(ArrDelay) AS avg_delay,
    COUNT(*) AS total_flights
FROM {{ref("flights_2020-2021")}}
GROUP BY Origin, Dest
HAVING COUNT(*) > 100  -- Only routes with significant traffic
ORDER BY avg_delay DESC
LIMIT 20