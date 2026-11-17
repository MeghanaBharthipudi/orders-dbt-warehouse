with source as (
    select * from {{ source('raw', 'customers') }}
)
select
    customer_id,
    customer_name,
    region,
    cast(signup_date as date) as signup_date
from source