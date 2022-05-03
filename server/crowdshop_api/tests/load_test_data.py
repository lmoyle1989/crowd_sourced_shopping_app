import csv
import os.path

from db import db
from db.stores import Stores


def drop_all():
    db.drop_all()


def load_stores_data():
    path = os.path.join(os.path.dirname(__file__), 'store-data.csv')
    with open(path, 'r') as stores:
        read_data = csv.DictReader(stores, delimiter=',')
        all_stores =[
            Stores(
                row["Name"],
                row["Address"],
                row["Latitude"],
                row["Longitude"]
            ) for row in read_data
        ]

    db.session.bulk_save_objects(all_stores)
    db.session.commit()



