import json


def test_store_name(app, client):
    storenamelike = 'Saf'
    lat = 44.56
    lon = -123.28
    response = client.get(f'/stores?name={storenamelike}&latitude='
                              f'{lat}&longitude={lon}')

    assert response.data is not None
    assert isinstance(json.loads(response.data.decode()), list)

