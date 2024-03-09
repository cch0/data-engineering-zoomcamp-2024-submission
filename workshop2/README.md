# Question 1


<br>

**Answer**: Yorkville East, Steinway

<br>

**Solution**:

step 1: calculate trip time (in seconds) and create a materialized view for it

```sql

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
```


<br>

step 2: select the trip which has the highest average trip time among all pickup+dropoff zones pairs.

```sql
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

```

<br>

**Result**:


```
 avg_trip_time | min_trip_time | max_trip_time |  pickup_zone   | dropoff_zone | highest_avg
---------------+---------------+---------------+----------------+--------------+--------------
  86373.000000 |  86373.000000 |  86373.000000 | Yorkville East | Steinway     | 86373.000000
(1 row)
```




---

# Question 2


<br>

**Answer**: 1 

<br>

**Explanation**: Based on the result from question 1 above, only one row is returned



---

# Question 3


<br>

**Answer**: LaGuardia Airport, Lincoln Square East, JFK Airport

<br>



**Solution**:

step 1: 

Uses the `trip_time` materialized view created for question 1, calculate the latest pickup timestamp. 

Use that information to select and count the trips that have pickup_time within 17 hours from the latest pickup timestamp. Limit the result to top 3.

Create another materialized view for it.


```sql
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

```

<br>


step 2: query the result from the materialized view

```sql
select *
from top3_pickup_zone_in_latest_17_hours_pickup
;
```

<br>


**Result**:

```
 count |     pickup_zone
-------+---------------------
    19 | LaGuardia Airport
    17 | JFK Airport
    17 | Lincoln Square East
(3 rows)
```




<br>
