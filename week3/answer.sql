# create external table
CREATE OR REPLACE EXTERNAL TABLE `axial-gist-411121.data_engineering_week3.green_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://cch-data-engineering-zoocamp-week3/green_tripdata_2022-*.parquet']
);

# query total count
SELECT count(*) FROM `axial-gist-411121.data_engineering_week3.green_tripdata`;




# distinct PULocationID count from external table
SELECT COUNT(DISTINCT(PULocationID)) FROM `axial-gist-411121.data_engineering_week3.green_tripdata`;



# create nonpartitioned table
CREATE OR REPLACE TABLE `axial-gist-411121.data_engineering_week3.green_nonpartitioned_tripdata`
AS SELECT * FROM `axial-gist-411121.data_engineering_week3.green_tripdata`;


# distinct PULocationID count from materialized table
SELECT COUNT(DISTINCT(PULocationID)) FROM `axial-gist-411121.data_engineering_week3.green_nonpartitioned_tripdata`;




# How many records have a fare_amount of 0?
select count(*) from `axial-gist-411121.data_engineering_week3.green_nonpartitioned_tripdata` where fare_amount = 0.0






# create table partitioned on 'lpep_pickup_datetime' and clustered on 'PUlocationID'
CREATE OR REPLACE TABLE `axial-gist-411121.data_engineering_week3.green_partitioned_tripdata`
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS (
  SELECT * FROM `axial-gist-411121.data_engineering_week3.green_tripdata`
);






# distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 from non-partitioned table
SELECT distinct(PULocationID) FROM  `axial-gist-411121.data_engineering_week3.green_nonpartitioned_tripdata`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30'







# distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 from partitioned table
SELECT distinct(PULocationID) FROM `axial-gist-411121.data_engineering_week3.green_partitioned_tripdata`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30'




SELECT count(*) FROM `axial-gist-411121.data_engineering_week3.green_partitioned_tripdata`


