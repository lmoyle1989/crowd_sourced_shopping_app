from db import db


class Users(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(60), unique=True, nullable=False)
    last_name = db.Column(db.String(60), unique=True, nullable=False)
    password = db.Column(db.String(32), nullable=False)
    email = db.Column(db.String(60), unique=True, nullable=False)
    uploads_count = db.Column(db.Integer)
    user_rank = db.Column(db.String(60), nullable=True)

    # for relationships
    uploads = db.relationship('Uploads', backref='user', lazy=True)

    def __init__(self, first_name, last_name, password, email, upload_count,
                 user_rank):
        self.first_name = first_name
        self.last_name = last_name
        self.password = password
        self.email = email
        self.uploads_count = upload_count
        self.user_rank = user_rank

