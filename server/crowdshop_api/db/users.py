from db import db


class Users(db.Model):

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    first_name = db.Column(db.String(60), unique=False, nullable=False)
    last_name = db.Column(db.String(60), unique=False, nullable=False)
    password = db.Column(db.String(32), nullable=False)
    email = db.Column(db.String(60), unique=True, nullable=False)
    uploads_count = db.Column(db.Integer)
    user_rank = db.Column(db.String(60), nullable=True)

    def __init__(self, first_name, last_name, password, email, upload_count=0,
                 user_rank='starter'):
        self.first_name = first_name
        self.last_name = last_name
        self.password = password
        self.email = email
        self.uploads_count = upload_count
        self.user_rank = user_rank

    def get_dict_repr(self):
        dictionary = {
            "id": self.id,
            "first_name": self.first_name,
            "last_name": self.last_name,
            "email": self.email,
            "uploads_count": self.uploads_count,
            "user_rank": self.user_rank
        }
        return dictionary

