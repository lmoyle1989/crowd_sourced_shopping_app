from db import db


class Stores(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(60), nullable=False)
    address = db.Column(db.String(120), nullable=False)
    latitude = db.Column(db.String(120), nullable=False)
    longitude = db.Column(db.String(120), nullable=False)

    # for relationships
    store_relationship = db.relationship('Uploads', backref='store', lazy=True)
