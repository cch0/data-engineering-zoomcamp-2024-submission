```python
if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    df_zero_paggenger = data[data['passenger_count'] == 0]
    print(f'Number of trips with zero passenger count is: {df_zero_paggenger.shape[0]}')
    
    df_zero_trip_distance = data[data['trip_distance'] == 0.0]
    print(f'Number of trips with zero trip distance is: {df_zero_trip_distance.shape[0]}')

    df_none_zero_passenger_and_none_zero_trip_distance = data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0.0)]
    print(f'Number of trips with non-zero paggenger count and non-zero trip distance is: {df_none_zero_passenger_and_none_zero_trip_distance.shape[0]}')

    return df_none_zero_passenger_and_none_zero_trip_distance


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
    assert output['passenger_count'].isin([0]).sum() == 0, "Expect no row has zero passenger_count"
    assert output['trip_distance'].isin([0]).sum() == 0, "Expect no row has zero trip_distance"


```