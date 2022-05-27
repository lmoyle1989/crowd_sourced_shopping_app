import csv
import os.path

from db import db as db
from db.stores import Stores
from db.uploads import Uploads
from db.tags import Tags
from db.users import Users
from db.tags_uploads import TagsUploads
from crowdshop.app import init_app
from datetime import datetime


def get_path(fname):
    return os.path.join(os.path.dirname(__file__), fname)


def drop_all():
    db.drop_all()


def make_all():
    load_stores_data()
    make_users()
    load_uploads()


def load_stores_data():
    path = get_path('store-data.csv')

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

def make_users():
    path = get_path('users-data.csv')
    with open(path, 'r') as users:
        read_data = csv.DictReader(users, delimiter=',')
        for row in read_data:
            user = Users(
                row["first_name"],
                row["last_name"],
                row["password"],
                row["email"],
                row["uploads_count"],
                row["user_rank"]
            )
            db.session.add(user)
            db.session.commit()

def load_uploads():
    path = get_path('uploads-data.csv')

    with open(path, 'r') as uploads:
        read_data = csv.DictReader(uploads, delimiter=',')
        for row in read_data:
            tag_ids = make_tag_instances(row["tags"])
            upload = Uploads(
                row["price"],
                datetime.strptime(row["date"], "%m/%d/%Y"),
                bool(row["sale"]),
                row["barcode"],
                row["userid"],
                row["storeid"]
            )
            make_tag_uploads_instances(tag_ids, upload)
            db.session.add(upload)
            db.session.commit()


def make_tag_instances(tags):
    """ create tag instances and return list of tags """
    tags = tags.split(', ')
    tag_entries = [Tags(t) for t in tags]
    return tag_entries


def make_tag_uploads_instances(tag_ids, upload):
    """ add tag to upload instance """
    for ti in tag_ids:
        upload.tag_upload_relationship.append(ti)


if __name__ == '__main__':
    # loads data into production DB
    # DB URI must be set to production URI in env
    # DROPS ALL, CREATES NEW, INSERTS DATA
    app = init_app('production')
    with app.app_context():
        drop_all()
        db.create_all()
        make_all()


