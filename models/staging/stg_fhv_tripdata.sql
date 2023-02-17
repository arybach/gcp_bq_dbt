{{ config( materialized = 'view') }}

with tripdata as
(
  select *,
    row_number() over(partition by dispatching_base_num, pickup_datetime, dropoff_datetime) as rn
  from {{ source('fhv_tripdata', 'trip_data') }}
  where dispatching_base_num is not null 
)
select 
	{{ dbt_utils.surrogate_key( [ 'dispatching_base_num', 'pickup_datetime', 'dropoff_datetime' ] ) }}  as  tripid, 
	dispatching_base_num as dispatch_base_id,
	
	-- timestamps 
	cast(pickup_datetime as timestamp) as pickup_datetime,
	cast(dropOff_datetime as timestamp) as dropoff_datetime,
	
	--location info
	cast(PUlocationID as integer) as pickup_locationid,
	cast(DOlocationID as numeric) as dropoff_locationid,
	
	-- additional info
	SR_Flag as flag, 
	Affiliated_base_number as affiliated_base_id

from tripdata
where rn=1 
{% if var('is_test_run', default=true) %}
	limit 100
{% endif %}
-- dbt build --m model.sql --var 'is_test_run: false'
-- to overwrite in command line