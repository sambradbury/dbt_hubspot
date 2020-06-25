with history as (

    select *
    from {{ var('company_property_history') }}

), windows as (

    select
        company_id,
        field_name,
        change_source,
        change_source_id,
        change_timestamp as valid_from,
        new_value,
        lead(change_timestamp) over (partition by company_id order by change_timestamp) as valid_to
    from history

), surrogate as (

    select 
        windows.*,
        {{ dbt_utils.surrogate_key(['field_name','company_id','valid_from']) }} as id
    from windows

)

select *
from surrogate