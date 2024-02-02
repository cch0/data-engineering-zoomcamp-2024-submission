```python

@transformer
def transform(data, *args, **kwargs):
    
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date

    print(data['lpep_pickup_date'])


    return data
    
```