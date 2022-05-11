import json

def test_add_user(client):
    response = client.post('/users', json={
        "fn": "somename",
        "ln": "somename",
        "email": "newemail@yahoo.com",
        "password": "1234"
    })

    assert response.data is not None
    assert json.loads(response.data.decode())["user_id"] is not None

