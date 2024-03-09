       
       
       Name        |       Type        | Is Hidden | Description
-------------------+-------------------+-----------+-------------
 location_id       | integer           | false     |
 borough           | character varying | false     |
 zone              | character varying | false     |
 service_zone      | character varying | false     |
 _row_id           | serial            | true      |
 primary key       | _row_id           |           |
 distribution key  | _row_id           |           |
 table description | taxi_zone         |           |