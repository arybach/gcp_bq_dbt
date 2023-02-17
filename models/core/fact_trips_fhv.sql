{{ config(materialized='table') }}

with fhv_data as (
    select *, 
        'FHV' as service_type 
    from {{ ref('stg_fhv_tripdata') }}
), 

dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)

-- 	tripid, 
--	dispatch_base_id,
	
	-- timestamps 
--	pickup_datetime,
--	dropoff_datetime,
	
	--location info
--	pickup_locationid,
--	dropoff_locationid,
	
	-- additional info
--	SR_Flag as flag, 
--	affiliated_base_id

select 
    fhv_data.tripid, 
    fhv_data.dispatch_base_id, 
    fhv_data.service_type, -- FHV 
    fhv_data.pickup_locationid, 
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    fhv_data.dropoff_locationid,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,  
    fhv_data.pickup_datetime, 
    fhv_data.dropoff_datetime, 
    fhv_data.flag, 
    fhv_data.affiliated_base_id
from fhv_data
inner join dim_zones as pickup_zone
on fhv_data.pickup_locationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on fhv_data.dropoff_locationid = dropoff_zone.locationid
-- added not null check for location ids
where fhv_data.pickup_locationid is not null and 
fhv_data.dropoff_locationid is not null