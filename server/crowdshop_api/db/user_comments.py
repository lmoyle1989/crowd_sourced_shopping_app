from db import db
from db.users import Users

class UserComments(db.Model):
    """Creates a table to hold comments for Live Feed page and connects to user id in Users table"""
    comment_id = db.column(db.Integer, primary_key=True, autoincrement=True)
    comment_user_id = db.column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    comment = db.column(db.String(500), nullable=False)
    date = db.column(db.DATETIME, nullable=False)

    comment_relationship = db.relationship('Users', backref='user_comments', lazy = True)

    def __init__(self, comment_user_id, comment, date):
        self.comment_user_id = comment_user_id
        self.comment = comment
        self.date = date
