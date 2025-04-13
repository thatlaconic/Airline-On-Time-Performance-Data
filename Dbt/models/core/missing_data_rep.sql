{{
    config(
        materialized='table'
    )
}}

SELECT 
    COUNT(*) - COUNT(DepTime) AS missing_dep_times,
    COUNT(*) - COUNT(ArrTime) AS missing_arr_times,
    COUNT(*) - COUNT(Tail_Number) AS missing_tail_numbers
FROM {{ref("flights_2020-2021")}}