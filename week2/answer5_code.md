```python 
if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    # get the column names before transformation
    column_names_before = list(data.columns.values)
    print(f'column names before changing: {column_names_before}\n')
    
    # use regex to capture columns with Camel case and trasform to snake case
    data.columns = data.columns.str.replace(r'([A-Z]\w+)([A-Z]\w+)',
                                    lambda x: "{}_{}".format(
                                        x.group(1).lower(), x.group(2).lower()) )

    # get the column names after transformation
    column_names_after = list(data.columns.values)
    print(f'column names after changing: {column_names_after}\n')

    # find the difference
    column_names_changed = [name for name in column_names_after if name not in column_names_before ]
    print(f'column with name changed are: {column_names_changed} and size is {len(column_names_changed)}')


    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'

    column_names = list(output.columns.values)

    assert 'vendor_id' in column_names, "Expect 'vendor_id' appear in one of the column names"
    assert output['passenger_count'].isin([0]).sum() == 0, "Expect no row has zero passenger_count"
    assert output['trip_distance'].isin([0]).sum() == 0, "Expect no row has zero trip_distance"
```