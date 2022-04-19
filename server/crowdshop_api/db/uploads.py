from db import db


class Uploads(db.Model):

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    store_id = db.Column(db.Integer, db.ForeignKey('stores.id'),
                         nullable=False)
    price = db.Column(db.Integer)
    upload_date = db.Column(db.DateTime, nullable=False)
    on_sale = db.Column(db.Boolean, default=False)
    barcode = db.Column(db.Integer, nullable=False)

    def __init__(self, price, upload_date, on_sale, barcode):
        self.price = price
        self.upload_date = upload_date
        self.on_sale = on_sale
        self.barcode = barcode



