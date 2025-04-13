{#
    This macro returns the description of the CancellationCode
#}

{% macro get_cancellation_code_description(CancellationCode) -%}

    case cast(CancellationCode as string)
        when 'A' then 'Carrier (airline fault)'
        when 'B' then 'Weather'
        when 'C' then 'NAS'
        when 'D' then 'Security'
        else 'EMPTY'
    end

{%- endmacro %}