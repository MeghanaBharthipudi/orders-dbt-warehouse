with source as (
    select * from {{ source('raw', 'orders_source') }}
)
select
    order_id,
    customer_id,
    status,
    amount,
    cast(updated_at as timestamp) as updated_at
from source