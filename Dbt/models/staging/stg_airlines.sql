{{
    config(
        materialized='view'
    )
}}

SELECT 
    cast(string_field_0 as string) as code,
    cast(string_field_1 as string) as airlines,
    FROM {{ source('staging', 'Airlines') }}


