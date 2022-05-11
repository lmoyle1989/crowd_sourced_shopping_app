import csv
import os.path

from db import db as db
from db.stores import Stores
from crowdshop.app import init_app


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


if __name__ == '__main__':
    # loads data into production DB
    # DB URI must be set to production URI in env
    # DROPS ALL, CREATES NEW, INSERTS DATA
    app = init_app('production')
    with app.app_context():
        drop_all()
        db.create_all()
        load_stores_data()


