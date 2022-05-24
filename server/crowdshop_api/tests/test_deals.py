from crowdshop.deals.dealrequests import DealInquirer


def test_find_items(app, client):
    items = {
        "location": (44.55, -123.292),
        "tags": [
            ["napkins", "100"],
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
                  f"upload id: {item[2]} "
                  f"uploads price: {item[3]} "
                  f"uploads on_sale?: {item[4]} "
                  f"uploads date: {item[5]} "
                  f"upload barcode: {item[6]}\n"
                  f"tag id: {item[7]} "
                  f"tag name: {item[8]}\n"
                  f"----------------------\n")
        assert len(deals.items_uploads) > 0

