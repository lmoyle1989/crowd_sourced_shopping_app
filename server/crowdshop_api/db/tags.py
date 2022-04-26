from db import db


class Tags(db.Model):

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    tag = db.Column(db.String(60), nullable=False)

    # for relationships
    upload_tag_relationship = db.relationship('TagsUploads', backref='tags',
                                              lazy=True)

    def __init__(self, tag):
        self.tag = tag
