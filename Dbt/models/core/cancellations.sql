{{
    config(
        materialized='table'
    )
}}


with cancellation as 
(SELECT 
    Year,
    Marketing_Airline_Network,
    CancellationCode,
    {{ get_cancellation_code_description("CancellationCode") }} as cancellation_code_description,
    COUNT(*) AS cancellation_count
FROM {{ref("flights_2020-2021")}}
WHERE Cancelled = 1
GROUP BY Year, Marketing_Airline_Network, CancellationCode)

SELECT 
Year,
airlines.Airlines,
CancellationCode,
cancellation_code_description,
cancellation_count
FROM cancellation
INNER JOIN {{ref("stg_airlines")}} airlines ON cancellation.Marketing_Airline_Network = airlines.code

