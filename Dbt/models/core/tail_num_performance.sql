{{
    config(
        materialized='table'
    )
}}

SELECT 
    Tail_Number,
    COUNT(*) AS flights_operated,
    AVG(ArrDelay) AS avg_delay,
    SUM(Distance) AS total_miles_flown
FROM {{ref("flights_2020-2021")}}
WHERE Tail_Number IS NOT NULL
GROUP BY Tail_Number
ORDER BY flights_operated DESC