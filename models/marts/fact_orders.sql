select
    o.order_id,            -- degenerate dimension (transaction id, no separate table)
    d.date_key,            -- FK → dim_date
    c.customer_key,        -- FK → dim_cust
    s.status_key,          -- FK → dim_status
    o.amount               -- measure (additive)
from {{ ref('stg_orders') }} o
left join {{ ref('dim_date') }}   d on o.updated_at::date = d.full_date
left join {{ ref('dim_cust') }}   c on o.customer_id     = c.customer_id
left join {{ ref('dim_status') }} s on o.status          = s.status_name