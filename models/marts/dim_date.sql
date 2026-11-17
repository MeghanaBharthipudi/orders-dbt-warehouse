with bounds as (
    select min(updated_at)::date as min_date,
           max(updated_at)::date as max_date
    from {{ ref('stg_orders') }}
),
spine as (
    select generate_series(min_date, max_date, interval '1 day')::date as date_day
    from bounds
)
select
    cast(to_char(date_day, 'YYYYMMDD') as integer) as date_key,   -- surrogate (smart key)
    date_day                                        as full_date,
    extract(year    from date_day)                  as year,
    extract(quarter from date_day)                  as quarter,
    extract(month   from date_day)                  as month,
    trim(to_char(date_day, 'Month'))                as month_name,
    extract(day     from date_day)                  as day_of_month,
    trim(to_char(date_day, 'Day'))                  as day_name,
    extract(isodow  from date_day)                  as day_of_week,
    (extract(isodow from date_day) in (6,7))        as is_weekend
from spine