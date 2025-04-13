{{
    config(
        materialized='table'
    )
}}

with delay_breakdown as (SELECT 
    Marketing_Airline_Network,
    SUM(CarrierDelay) AS carrier_delay,
    SUM(WeatherDelay) AS weather_delay,
    SUM(NASDelay) AS nas_delay,
    SUM(SecurityDelay) AS security_delay,
    SUM(LateAircraftDelay) AS late_aircraft_delay,
    (SUM(CarrierDelay) + SUM(WeatherDelay) + SUM(NASDelay) + SUM(SecurityDelay) + SUM(LateAircraftDelay)) as total_delay
FROM {{ref("flights_2020-2021")}}
GROUP BY Marketing_Airline_Network
ORDER BY total_delay DESC)

SELECT 
Marketing_Airline_Network, 
airlines.Airlines,
carrier_delay,
weather_delay,
nas_delay,
security_delay,
late_aircraft_delay,
total_delay
FROM delay_breakdown db
INNER JOIN {{ref("stg_airlines")}} airlines ON db.Marketing_Airline_Network = airlines.code