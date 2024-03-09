 
 
 vendorid              | bigint                      | false     |
 tpep_pickup_datetime  | timestamp without time zone | false     |
 tpep_dropoff_datetime | timestamp without time zone | false     |
 passenger_count       | numeric                     | false     |
 trip_distance         | numeric                     | false     |
 ratecodeid            | numeric                     | false     |
 store_and_fwd_flag    | character varying           | false     |
 pulocationid          | bigint                      | false     |
 dolocationid          | bigint                      | false     |
 payment_type          | bigint                      | false     |
 fare_amount           | numeric                     | false     |
 extra                 | numeric                     | false     |
 mta_tax               | numeric                     | false     |
 tip_amount            | numeric                     | false     |
 tolls_amount          | numeric                     | false     |
 improvement_surcharge | numeric                     | false     |
 total_amount          | numeric                     | false     |
 congestion_surcharge  | numeric                     | false     |
 airport_fee           | numeric                     | false     |
 _row_id               | serial                      | true      |
 primary key           | _row_id                     |           |
 distribution key      | _row_id                     |           |
 table description     | trip_data                   |           |

