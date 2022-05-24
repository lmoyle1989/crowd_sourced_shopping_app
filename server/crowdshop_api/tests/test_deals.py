from crowdshop.deals.dealrequests import DealInquirer
import json


def test_find_items(app, client):
    items = {
        "location": (44.55, -123.292),
        "tags": [
            ["napkins", "100 count"],
            ["captain crunch", "cereal"],
            ["chips"],
            ["cereal", "cheerios"]
        ]
    }
    with app.app_context():
        deals = DealInquirer(items["tags"], user_location=items["location"])
        deals.get_best_deal()
        print(deals.points)
        print(deals.items_uploads)

        for item in deals.items_uploads:
            print(f"---------------------\n"
                  f"store id: {item[0]} \n"
                  f"store address: {item[1]}\n"
                  f"store name: {item[2]}"
                  f"upload id: {item[3]} "
                  f"uploads price: {item[4]} "
                  f"uploads on_sale?: {item[5]} "
                  f"uploads date: {item[6]} "
                  f"upload barcode: {item[7]}\n"
                  f"tag id: {item[8]} "
                  f"tag name: {item[9]}\n"
                  f"----------------------\n")
        assert len(deals.items_uploads) > 0


def test_deal_route(app, client):
    response = client.post('/deals', json={
        "location": (44.55, -123.292),
        "tags": [
            ["napkins", "100 count"],
            ["captain crunch", "cereal"],
            ["chips"],
            ["cereal", "cheerios"]
        ]
    })
    res_data = json.loads(response.data.decode())
    print(res_data)

    assert len(res_data) > 0
    assert res_data[0].get("average_price", None) is not None

