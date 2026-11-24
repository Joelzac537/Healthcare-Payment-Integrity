with source as (
    select * from {{ source('payment_integrity', 'leie_exclusions') }}
),
renamed as (
    select
    nullif(trim(LASTNAME),'') as last_name,
    nullif(trim(FIRSTNAME),'') as first_name,
    nullif(trim(MIDNAME),'') as middle_name, 
    nullif(trim(BUSNAME),'') as business_name, 
    nullif(trim(GENERAL),'') as general_category, 
    nullif(trim(SPECIALTY),'') as specialty, 
    nullif(trim(UPIN),'') as upin, 
    nullif(trim(NPI),'0000000000') as npi, 
    nullif(trim(CITY),'') as city, 
    nullif(trim(STATE),'') as state, 
    nullif(trim(ZIP),'') as zip_code, 
    nullif(trim(EXCLTYPE),'') as exclusion_type, 
    parse_date('%Y%m%d',EXCLDATE) as exclusion_date, 
    nullif(trim(REINDATE),'00000000') as reinstatement_date, 
    nullif(trim(WAIVERDATE),'00000000') as waiver_date, 
    nullif(trim(WVRSTATE),'') as waiver_state
    from source
),
final as (
    select *,
    CASE
        when last_name is not null then 'individual'
        when business_name is not null then 'business'
        else 'unknown'
    END as entity_type
    from renamed
)

select * from final
