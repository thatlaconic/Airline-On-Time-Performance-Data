{{
    config( 
        materialized='table'
        )
}}


select *
from {{ ref("stg_flights_2020") }}
union all
select *
from {{ ref("stg_flights_2021")}}
