from crowdshop.deals.dealrequests import DealInquirer


def test_find_items(app, client):
    items = {
        "location": (44.3132424, -123),
        "tags": [
            ["napkins", "100"],
            ["chips"],
            ["cereal", "cheerios"]
        ]
    }
    with app.app_context():
        deals = DealInquirer(items["tags"], user_location=items["location"])
        deals.get_perimeter()
        deals.find_items()
        print(deals.points)
        print(deals.items_uploads)
        for store in deals.items_uploads:
            print(store.name)
        assert len(deals.items_uploads) > 0

