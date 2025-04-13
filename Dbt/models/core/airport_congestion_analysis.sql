{{
    config(
        materialized='table'
    )
}}


SELECT 
    Year,
    Origin,
    AVG(TaxiOut) AS avg_taxi_out_time,
    AVG(DepDelay) AS avg_dep_delay
FROM {{ref("flights_2020-2021")}}
GROUP BY Year, Origin
ORDER BY Origin