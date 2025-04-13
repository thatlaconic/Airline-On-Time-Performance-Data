{{
    config(
        materialized='table'
    )
}}

WITH delay_analysis as (SELECT 
    Marketing_Airline_Network,
    AVG(DepDelay) AS avg_departure_delay,
    AVG(ArrDelay) AS avg_arrival_delay,
    SUM(CASE WHEN DepDel15 = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS dep_delay_percentage,
    SUM(CASE WHEN ArrDel15 = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS arr_delay_percentage
FROM {{ref("flights_2020-2021")}}
GROUP BY Marketing_Airline_Network
ORDER BY avg_departure_delay DESC )

SELECT 
Marketing_Airline_Network, 
airlines.Airlines,
avg_departure_delay,
dep_delay_percentage,
arr_delay_percentage,
FROM delay_analysis
INNER JOIN {{ref("stg_airlines")}} airlines ON delay_analysis.Marketing_Airline_Network = airlines.code