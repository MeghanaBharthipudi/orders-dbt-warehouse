{% snapshot scd_customers %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='check',
      check_cols=['region']
    )
}}

select customer_id, customer_name, region, signup_date
from {{ ref('stg_customers') }}

{% endsnapshot %}