with statuses as (
    select distinct status from {{ ref('stg_orders') }}
)
select
    row_number() over (order by status)   as status_key,       -- surrogate key
    status                                 as status_name,
    case when status in ('delivered','cancelled','returned')
         then 'Closed' else 'Open' end     as status_category
from statuses