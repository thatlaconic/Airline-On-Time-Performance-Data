{{
    config(
        materialized='table'
    )
}}


SELECT 
    Operating_Airline,
    COUNT(*) AS diversion_count,
    AVG(DivArrDelay) AS avg_diversion_delay
FROM {{ref("flights_2020-2021")}}
WHERE Diverted = 1
GROUP BY Operating_Airline
ORDER BY diversion_count DESC