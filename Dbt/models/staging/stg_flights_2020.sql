{{
    config(
        materialized='view'
    )
}}

with flightdata as 
(
  select *,
    row_number() over(partition by FlightDate, Flight_Number_Marketing_Airline, Tail_Number, Dest) as rn
  from {{ source( 'staging','Flights_2020') }}
)


select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['FlightDate', 'Flight_Number_Marketing_Airline','Tail_Number','Dest']) }} as tripid,
    {{ dbt.safe_cast("Year", api.Column.translate_type("integer")) }} as Year,
    {{ dbt.safe_cast("Quarter", api.Column.translate_type("integer")) }} as Quarter,
    {{ dbt.safe_cast("Month", api.Column.translate_type("integer")) }} as Month,
    {{ dbt.safe_cast("DayofMonth", api.Column.translate_type("integer")) }} as DayofMonth,
    {{ dbt.safe_cast("DayofWeek", api.Column.translate_type("integer")) }} as DayofWeek,
  

--date
    cast(FlightDate as date) as FlightDate,
    

--airlines
    cast(Marketing_Airline_Network as string) as Marketing_Airline_Network,
    cast(Operated_or_Branded_Code_Share_Partners as string) as Operated_or_Branded_Code_Share_Partners,
    {{ dbt.safe_cast("DOT_ID_Marketing_Airline", api.Column.translate_type("integer")) }} as DOT_ID_Marketing_Airline,
    cast(IATA_Code_Marketing_Airline as string) as IATA_Code_Marketing_Airline,
    {{ dbt.safe_cast("Flight_Number_Marketing_Airline", api.Column.translate_type("integer")) }} as Flight_Number_Marketing_Airline,
    cast(Originally_Scheduled_Code_Share_Airline as string) as Originally_Scheduled_Code_Share_Airline,
    cast(DOT_ID_Originally_Scheduled_Code_Share_Airline as string) as DOT_ID_Originally_Scheduled_Code_Share_Airline,
    cast(IATA_Code_Originally_Scheduled_Code_Share_Airline as string) as IATA_Code_Originally_Scheduled_Code_Share_Airline,
    cast(`Operating_Airline ` as string) as Operating_Airline,
    {{ dbt.safe_cast("DOT_ID_Operating_Airline", api.Column.translate_type("integer")) }} as DOT_ID_Operating_Airline,
    cast(IATA_Code_Operating_Airline as string) as IATA_Code_Operating_Airline,
    cast(Flight_Num_Originally_Scheduled_Code_Share_Airline as string) as Flight_Num_Originally_Scheduled_Code_Share_Airline,

    cast(Tail_Number as string) as Tail_Number,
    {{ dbt.safe_cast("Flight_Number_Operating_Airline", api.Column.translate_type("integer")) }} as Flight_Number_Operating_Airline,
    {{ dbt.safe_cast("OriginAirportID", api.Column.translate_type("integer")) }} as OriginAirportID,
    {{ dbt.safe_cast("OriginAirportSeqID", api.Column.translate_type("integer")) }} as OriginAirportSeqID,
    {{ dbt.safe_cast("OriginCityMarketID", api.Column.translate_type("integer")) }} as OriginCityMarketID,
    cast(Origin as string) as Origin,
    cast(OriginCityName as string) as OriginCityName,
    cast(OriginState as string) as OriginState,
    {{ dbt.safe_cast("OriginStateFips", api.Column.translate_type("integer")) }} as OriginStateFips,
    cast(OriginStateName as string) as OriginStateName,
    {{ dbt.safe_cast("OriginWac", api.Column.translate_type("integer")) }} as OriginWac,
    {{ dbt.safe_cast("DestAirportID", api.Column.translate_type("integer")) }} as DestAirportID,
    {{ dbt.safe_cast("DestAirportSeqID", api.Column.translate_type("integer")) }} as DestAirportSeqID,
    {{ dbt.safe_cast("DestCityMarketID", api.Column.translate_type("integer")) }} as DestCityMarketID,
    cast(Dest as string) as Dest,
    cast(DestCityName as string) as DestCityName,
    cast(DestState as string) as DestState,
    {{ dbt.safe_cast("DestStateFips", api.Column.translate_type("integer")) }} as DestStateFips,
    cast(DestStateName as string) as DestStateName,
    {{ dbt.safe_cast("DestWac", api.Column.translate_type("integer")) }} as DestWac,
    {{ dbt.safe_cast("CRSDepTime", api.Column.translate_type("integer")) }} as CRSDepTime,
    {{ dbt.safe_cast("DepTime", api.Column.translate_type("integer")) }} as DepTime,
    {{ dbt.safe_cast("DepDelay", api.Column.translate_type("float")) }} as DepDelay,
    {{ dbt.safe_cast("DepDelayMinutes", api.Column.translate_type("float")) }} as DepDelayMinutes,
    {{ dbt.safe_cast("DepDel15", api.Column.translate_type("float")) }} as DepDel15,
    {{ dbt.safe_cast("DepartureDelayGroups", api.Column.translate_type("integer")) }} as DepartureDelayGroups,
    cast(DepTimeBlk as string) as DepTimeBlk,
    {{ dbt.safe_cast("TaxiOut", api.Column.translate_type("float")) }} as TaxiOut,
    {{ dbt.safe_cast("WheelsOff", api.Column.translate_type("integer")) }} as WheelsOff,
    {{ dbt.safe_cast("WheelsOn", api.Column.translate_type("integer")) }} as WheelsOn,
    {{ dbt.safe_cast("TaxiIn", api.Column.translate_type("float")) }} as TaxiIn,
    {{ dbt.safe_cast("CRSArrTime", api.Column.translate_type("integer")) }} as CRSArrTime,
    {{ dbt.safe_cast("ArrTime", api.Column.translate_type("integer")) }} as ArrTime,
    {{ dbt.safe_cast("ArrDelay", api.Column.translate_type("float")) }} as ArrDelay,
    {{ dbt.safe_cast("ArrDelayMinutes", api.Column.translate_type("float")) }} as ArrDelayMinutes,
    {{ dbt.safe_cast("ArrDel15", api.Column.translate_type("float")) }} as ArrDel15,
    {{ dbt.safe_cast("ArrivalDelayGroups", api.Column.translate_type("integer")) }} as ArrivalDelayGroups,
    cast(ArrTimeBlk as string) as ArrTimeBlk,
    {{ dbt.safe_cast("Cancelled", api.Column.translate_type("float")) }} as Cancelled,
    cast(CancellationCode as string) as CancellationCode,
    {{ dbt.safe_cast("Diverted", api.Column.translate_type("float")) }} as Diverted,
    {{ dbt.safe_cast("CRSElapsedTime", api.Column.translate_type("float")) }} as CRSElapsedTime,
    {{ dbt.safe_cast("ActualElapsedTime", api.Column.translate_type("float")) }} as ActualElapsedTime,
    {{ dbt.safe_cast("AirTime", api.Column.translate_type("float")) }} as AirTime,
    {{ dbt.safe_cast("Flights", api.Column.translate_type("float")) }} as Flights,
    {{ dbt.safe_cast("Distance", api.Column.translate_type("float")) }} as Distance,
    {{ dbt.safe_cast("DistanceGroup", api.Column.translate_type("integer")) }} as DistanceGroup,
    {{ dbt.safe_cast("CarrierDelay", api.Column.translate_type("float")) }} as CarrierDelay,
    {{ dbt.safe_cast("WeatherDelay", api.Column.translate_type("float")) }} as WeatherDelay,
    {{ dbt.safe_cast("NASDelay", api.Column.translate_type("float")) }} as NASDelay,
    {{ dbt.safe_cast("SecurityDelay", api.Column.translate_type("float")) }} as SecurityDelay,
    {{ dbt.safe_cast("LateAircraftDelay", api.Column.translate_type("float")) }} as LateAircraftDelay,
    {{ dbt.safe_cast("FirstDepTime", api.Column.translate_type("float")) }} as FirstDepTime,
    {{ dbt.safe_cast("TotalAddGTime", api.Column.translate_type("float")) }} as TotalAddGTime,
    {{ dbt.safe_cast("LongestAddGTime", api.Column.translate_type("float")) }} as LongestAddGTime,
    {{ dbt.safe_cast("DivAirportLandings", api.Column.translate_type("integer")) }} as DivAirportLandings,
    {{ dbt.safe_cast("DivReachedDest", api.Column.translate_type("float")) }} as DivReachedDest,
    {{ dbt.safe_cast("DivActualElapsedTime", api.Column.translate_type("float")) }} as DivActualElapsedTime,
    {{ dbt.safe_cast("DivArrDelay", api.Column.translate_type("float")) }} as DivArrDelay,
    {{ dbt.safe_cast("DivDistance", api.Column.translate_type("float")) }} as DivDistance
from flightdata
where rn = 1


-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=false) %}

  limit 100

{% endif %}
