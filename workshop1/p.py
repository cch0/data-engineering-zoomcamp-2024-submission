import dlt

def people_1():
    for i in range(1, 6):
        yield {"ID": i, "Name": f"Person_{i}", "Age": 25 + i, "City": "City_A"}


def people_2():
    for i in range(3, 9):
        yield {"ID": i, "Name": f"Person_{i}", "Age": 30 + i, "City": "City_B", "Occupation": f"Job_{i}"}



pipeline = dlt.pipeline(pipeline_name="people",
						destination='duckdb', 
						dataset_name='people_data')



data1 = []
data2 = []

for item in people_1():
    data1.append(item)

for item in people_2():
  
    data2.append(item)


info = pipeline.run(data1, 
                    table_name="people", 
                    write_disposition="merge",
                    primary_key="id"
                    )


info = pipeline.run(data2, 
                    table_name="people", 
                    write_disposition="merge",
                    primary_key="id"
                    )


with pipeline.sql_client() as client:
    with client.execute_query(
        'SELECT *  FROM people'
    ) as table:
        data_df = table.df()


print('sum of all ages is', data_df["age"].sum())
print(data_df)

