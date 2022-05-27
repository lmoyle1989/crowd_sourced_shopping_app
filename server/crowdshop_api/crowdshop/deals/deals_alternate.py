# This is an alternate implementation of the deals algorithm in pure python that is less query-heavy.
# match_list() works only on the test data so the output can be visualized, create_store_uploads_dict() does not work with how the
#   DB is currently implemented, but would just put query data into a consumable dictionary for match_list(). 
# It is not as performant as the currently implemented version in dealrequests.py, but I (Lucas Moyle) wanted to keep it in the repo
#   in case anyone comes back to this and as a record for time spent on the project w.r.t. grading.

test_shopping_list = [
    ["cookies", "chocolate"],
    ["vanilla", "cookies"],
    ["toilet", "paper", "charmin", "10-pack"],
    ["red", "wine"],
    ["potato", "chips", "ruffles"],
    ["potato", "chips", "lays"],
    ["doritos", "chips", "cool", "ranch"],
    ["napkins"]
]

test_uploads = {
    "1": {
        "price": 1.99,
        "tags": ["potato"]
    },
    "2": {
        "price": 5.99,
        "tags": ["cookies", "chocolate", "chip"]
    },
    "4": {
        "price": 4.00,
        "tags": ["potato", "chips", "ruffles"]
    },
    "7": {
        "price": 2.50,
        "tags": ["cookies"]
    },
    "9": {
        "price": 7.99,
        "tags": ["toilet", "paper"]
    },
    "10": {
        "price": 5.0,
        "tags": ["doritos", "ranch", "cool", "corn", "chips"]
    },
    "11": {
        "price": 5.50,
        "tags": ["doritos", "ranch", "cool", "corn", "chips"]
    }
}

def match_list(store_uploads_dict, shopping_list):
    result = []
    # iterate over the input shopping list arrays of tags
    for item_tags in shopping_list:
        matches_for_item_dict = {}
        # for each item in the input shopping list, go through every upload at this store
        for upload_id in store_uploads_dict:
            # for each upload, find the tag intersections for the current shopping list item
            tag_intersection = set(item_tags).intersection(set(store_uploads_dict[upload_id]["tags"]))
            # if an upload has at least one matching tag, record it into a list of matching uploads for this item
            if len(tag_intersection) > 0:
                temp = {}
                temp["match_count"] = len(tag_intersection)
                #temp["matching_tags"] = tag_intersection
                temp["price"] = test_uploads[upload_id]["price"]
                matches_for_item_dict[upload_id] = temp
        # sort our list of uploads with matching tags by the greatest number of matching tags (this returns a list so we have to rebuild it)
        # secondary sort on price (we use price * -1 here since reverse=True, so we get the lowest cost with most matched tags first)
        sorted_matches = sorted(matches_for_item_dict, key=lambda x: (matches_for_item_dict[x]['match_count'], matches_for_item_dict[x]['price'] * -1), reverse=True)
        sorted_matches_for_item_dict = {}
        # rebuild our matched tags dictionary so that it is sorted by most number of tags
        for id in sorted_matches:
            sorted_matches_for_item_dict[id] = matches_for_item_dict[id]
        # attach our dictionary of sorted matching uploads to our result list which is indexed in the same order as the original input shopping list
        result.append(sorted_matches_for_item_dict)
    return result

for x in match_list(test_uploads, test_shopping_list):
    print(x)

def create_store_uploads_dict(target_store_id):
    uploads_query = Uploads.query \
        .with_entities(
            Uploads.id,
            Uploads.price,
            Uploads.on_sale,
            Uploads.upload_date,
            Tags.tag              
        ) \
        .join(TagsUploads, isouter=True) \
        .join(Tags, isouter=True) \
        .filter_by(store_id = target_store_id) \
        .all()
    store_uploads_dict = {}
    for row in uploads_query:
        if row.id not in store_uploads_dict:
            upload_data = {
                "price": row.price,
                "on_sale": row.on_sale,
                "upload_date": row.upload_date,
                "tags": []
            }
            upload_data["tags"].append(row.tag)
            store_uploads_dict[row.id] = upload_data
        else:
            store_uploads_dict[row.id]["tags"].append(row.tag)
    return store_uploads_dict
