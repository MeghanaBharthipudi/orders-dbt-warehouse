# Orders Analytics — Modern Data Stack (dbt + PostgreSQL)

An end-to-end **analytics engineering** project: raw order data is transformed into a tested, documented **dimensional model (star schema)** on a cloud data warehouse, using **dbt**. Includes **SCD Type 2** history tracking and automated **data-quality tests**.

---

## Architecture

```
raw.orders_source ─┐
                   ├─► staging (views) ─► dimensions + fact (tables) ─► BI
raw.customers ─────┘                        │
                                            └─► snapshot (SCD2 history)
```

| Layer | Models | Materialization |
|-------|--------|-----------------|
| **Staging** | `stg_orders`, `stg_customers` | views (clean + typed, 1:1 with source) |
| **Marts (star schema)** | `dim_date`, `dim_cust`, `dim_status`, `fact_orders` | tables |
| **Snapshot** | `scd_customers` | SCD2 history table |

## Dimensional model

- **Grain:** one row per order (`fact_orders`).
- **Degenerate dimension:** `order_id` kept in the fact (no separate table).
- **Surrogate keys:** integer keys on each dimension; the fact carries `date_key`, `customer_key`, `status_key` as foreign keys.
- **`dim_date`:** generated date spine (`generate_series`) with `YYYYMMDD` smart key and calendar attributes.
- **Measure:** `amount` (additive).

```
         dim_date
            │
 dim_cust ─ fact_orders ─ dim_status
```

## SCD Type 2 (history tracking)

Customer `region` is tracked with a **dbt snapshot** using the **`check` strategy** (the source has no `updated_at`, so changes are detected by comparing values). When a region changes, dbt closes the old version (`dbt_valid_to`) and inserts a new current one (`dbt_valid_to = null`) — full point-in-time history, automatically.

## Data quality

**14 dbt tests** enforce integrity on every run:

- `not_null` / `unique` — grain and surrogate-key integrity
- `accepted_values` — `status` restricted to the valid set
- `relationships` — **referential integrity**: every fact foreign key exists in its dimension (zero orphan keys)

> Validated by deliberately corrupting one record — the `relationships` test flagged it, proving the pipeline catches bad data before it reaches a dashboard.

## Tech stack

**dbt-core** · **dbt-postgres** · **PostgreSQL (Neon, cloud)** · **SQL** · **Jinja**

## How to run

```bash
# 1. install
pip install dbt-postgres

# 2. configure ~/.dbt/profiles.yml with your warehouse connection

# 3. build + test + snapshot + docs
dbt run          # builds staging, dimensions, and the fact
dbt test         # runs the 14 data-quality tests
dbt snapshot     # captures SCD2 history for customers
dbt docs generate && dbt docs serve   # lineage graph + model docs
```

## Project structure

```
orders_dwh/
├── models/
│   ├── staging/   stg_orders.sql, stg_customers.sql, _sources.yml
│   └── marts/     dim_date.sql, dim_cust.sql, dim_status.sql, fact_orders.sql, _marts.yml
├── snapshots/     scd_customers.sql
└── dbt_project.yml
```

## Skills demonstrated

Dimensional modeling (Kimball) · star schema · SCD Type 2 · surrogate keys · data-quality testing · analytics engineering with dbt · cloud data warehouse · documentation & lineage.
