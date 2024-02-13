
# create external table from bucket with parquet data
CREATE OR REPLACE EXTERNAL TABLE `axial-gist-411121.nyc_tripdata.fhv_tripdata_external`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://cch-fhv_tripdata-2029-parquet/*']
);


# distinct yeat from pickup_datetime
with tripdata as (
SELECT *, extract(year from pickup_datetime) as year 
FROM `axial-gist-411121.nyc_tripdata.fhv_tripdata_external` 
)
select distinct(year)
from tripdata


