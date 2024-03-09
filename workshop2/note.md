

# question 1

## create trip time

CREATE MATERIALIZED VIEW IF NOT EXISTS trip_time AS
with trip_data_tmp as (
    select 
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        pulocationid, 
        dolocationid,
        EXTRACT(EPOCH FROM (tpep_dropoff_datetime - tpep_pickup_datetime)) as trip_time
    from trip_data
)
select 
    trip_data_tmp.tpep_pickup_datetime,
    trip_data_tmp.tpep_dropoff_datetime,
    pickup_taxi_zone.zone as pickup_zone, 
    dropoff_taxi_zone.zone as dropoff_zone, 
    trip_data_tmp.trip_time as trip_time
from trip_data_tmp
join taxi_zone as pickup_taxi_zone 
    on trip_data_tmp.pulocationid = pickup_taxi_zone.location_id
join taxi_zone as dropoff_taxi_zone 
    on trip_data_tmp.dolocationid = dropoff_taxi_zone.location_id
;


## drop view

DROP MATERIALIZED VIEW IF EXISTS stats_trip_time;

DROP MATERIALIZED VIEW IF EXISTS trip_time; 


## see the view
select *
from trip_time
limit 10
;



## calculate avg, min and max trip time for each
CREATE MATERIALIZED VIEW stats_trip_time AS
select 
    avg(trip_time) as avg_trip_time, 
    min(trip_time) as min_trip_time, 
    max(trip_time) as max_trip_time,
    pickup_zone,
    dropoff_zone
from trip_time
group by pickup_zone, dropoff_zone
;


## trip_time with same pickup and dropoff zone
select *
from trip_time
where pickup_zone=dropoff_zone
;



## pickup+dropoff pair with highest avg trip_time
## this solution uses second materialized view stats_trip_time
with highest_avg_trip_time as (
    select 
        max(avg_trip_time) as highest_avg
    from stats_trip_time    
)
select *
from stats_trip_time, highest_avg_trip_time
where stats_trip_time.avg_trip_time = highest_avg_trip_time.highest_avg
;


## second solution which does not need the second view

with highest_avg_trip_time as (
    select max(avg_trip_time) as highest_avg
    from (
        select 
            avg(trip_time) as avg_trip_time
        from trip_time
        group by pickup_zone, dropoff_zone    
    )
)
select *
from stats_trip_time, highest_avg_trip_time
where stats_trip_time.avg_trip_time = highest_avg_trip_time.highest_avg
;

# ##########################################################################


# question 3


## drop the view
DROP MATERIALIZED VIEW IF EXISTS top3_pickup_zone_in_latest_17_hours_pickup;


## select trips with pickup time within the past 17 hours from the latest pickup time.
## create materialized view for it

CREATE MATERIALIZED VIEW IF NOT EXISTS top3_pickup_zone_in_latest_17_hours_pickup AS
with latest_pickup as (
    select max(tpep_pickup_datetime) as time
    from trip_time
)
select count(*) as count, pickup_zone
from trip_time, latest_pickup
where tpep_pickup_datetime > (latest_pickup.time - INTERVAL '17' HOUR)
group by pickup_zone
order by count desc
limit 3
;



## view the result
select *
from top3_pickup_zone_in_latest_17_hours_pickup
;

```
 count |     pickup_zone
-------+---------------------
    19 | LaGuardia Airport
    17 | JFK Airport
    17 | Lincoln Square East
(3 rows)
```


