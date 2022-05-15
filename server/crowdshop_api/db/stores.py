from db import db


class Stores(db.Model):

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(60), nullable=False)
    address = db.Column(db.String(120), nullable=False)
    latitude = db.Column(db.FLOAT(precision=32), nullable=False)
    longitude = db.Column(db.FLOAT(precision=32), nullable=False)

    def __init__(self, name, address, latitude, longitude):
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude

    def get_dict_repr(self):
        dictionary = {
            "id": self.id,
            "name": self.name,
            "address": self.address,
            "latitude": self.latitude,
            "longitude": self.longitude
        }
        return dictionary
