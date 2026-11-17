select
    row_number() over (order by customer_id) as customer_key,  -- surrogate key
    customer_id,                                               -- natural key
    customer_name,
    region,
    signup_date
from {{ ref('stg_customers') }}