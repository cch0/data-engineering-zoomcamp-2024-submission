
# Question 1: Which tag has the following text? - Automatically remove the container when it exits

--rm


# Question 2: What is version of the package wheel ?

0.42.0



## Prepare Postgres

(base) will@instance-1:~/data-engineering-zoomcamp/01-docker-terraform/2_docker_sql$ ./ingest.sh 
inserted another chunk, took 6.881 second
inserted another chunk, took 6.884 second
/home/will/data-engineering-zoomcamp/01-docker-terraform/2_docker_sql/ingest_data.py:50: DtypeWarning: Columns (3) have mixed types. Specify dtype option on import or set low_memory=False.
  df = next(df_iter)
inserted another chunk, took 7.159 second
inserted another chunk, took 2.877 second
Finished ingesting data into the postgres database


# Question 3: How many taxi trips were totally made on September 18th 2019?

select count(*)
from green_taxi_trips
where lpep_pickup_datetime >= '2019-09-18'
and lpep_dropoff_datetime < '2019-09-19'



15612


# Question 4. Largest trip for each day

## solution based on trip duration

select data.lpep_pickup_datetime, data.duration
from
(
select lpep_pickup_datetime, (lpep_dropoff_datetime - lpep_pickup_datetime) as duration
from green_taxi_trips	
) data
join	
(
select max(lpep_dropoff_datetime - lpep_pickup_datetime) as max_duration
from green_taxi_trips
) max_data
on data.duration = max_data.max_duration


"2019-09-26 08:58:52"	"4 days 04:45:02"


##  solution based on trip distance

select data.lpep_pickup_datetime
from (
	select lpep_pickup_datetime, trip_distance
	from green_taxi_trips
) data
join
(
select max(trip_distance) as max_trip_distance
from green_taxi_trips
) as max_distance
on data.trip_distance = max_distance.max_trip_distance

2019-09-26 19:32:52



2019-09-26


# Question 5: Three biggest pick up Boroughs


select data.*
from
(
select taxi_zone_lookup."Borough", sum(trip.total_amount) as total_amount
from green_taxi_trips trip 
join
(
	select "LocationID", "Borough"
	from taxi_zone_lookup
	where "Borough" != 'Unknown'
) taxi_zone_lookup
on trip."PULocationID" = taxi_zone_lookup."LocationID"
group by taxi_zone_lookup."Borough"
order by total_amount desc
) as data
where "total_amount" > 50000
limit 3






"Brooklyn" "Manhattan" "Queens"


# Question 6: Largest tip


select *
from
(
	select zone."Zone", max(tip_amount) as max_tip
	from
	(
		select "PULocationID", "DOLocationID", "tip_amount" 
		from green_taxi_trips
		where "PULocationID" = (
			select "LocationID"
			from taxi_zone_lookup
			where "Zone" = 'Astoria'
			)
		and "lpep_pickup_datetime" >= '2019-09-01'
		and "lpep_pickup_datetime" < '2019-10-01'
	) trips
	JOIN 	
	(
		select "LocationID", "Zone"
		from taxi_zone_lookup
	) zone
	on trips."DOLocationID" = zone."LocationID"
	group by zone."Zone"
) as max_data
order by max_data."max_tip" desc



JFK Airport

# ==========================================================



# Question 7: 



(base) will@instance-1:~/data-engineering-zoomcamp/01-docker-terraform/1_terraform_gcp/terraform/terraform_with_variables$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.demo_dataset will be created
  + resource "google_bigquery_dataset" "demo_dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "demo_dataset"
      + default_collation          = (known after apply)
      + delete_contents_on_destroy = false
      + effective_labels           = (known after apply)
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + is_case_insensitive        = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "US"
      + max_time_travel_hours      = (known after apply)
      + project                    = "axial-gist-411121"
      + self_link                  = (known after apply)
      + storage_billing_model      = (known after apply)
      + terraform_labels           = (known after apply)
    }

  # google_storage_bucket.demo-bucket will be created
  + resource "google_storage_bucket" "demo-bucket" {
      + effective_labels            = (known after apply)
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "US"
      + name                        = "cch-terraform-demo-terra-bucket"
      + project                     = (known after apply)
      + public_access_prevention    = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = (known after apply)
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "AbortIncompleteMultipartUpload"
            }
          + condition {
              + age                   = 1
              + matches_prefix        = []
              + matches_storage_class = []
              + matches_suffix        = []
              + with_state            = (known after apply)
            }
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.demo_dataset: Creating...
google_storage_bucket.demo-bucket: Creating...
google_bigquery_dataset.demo_dataset: Creation complete after 1s [id=projects/axial-gist-411121/datasets/demo_dataset]
google_storage_bucket.demo-bucket: Creation complete after 1s [id=cch-terraform-demo-terra-bucket]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.


