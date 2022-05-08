from db import db


class TagsUploads(db.Model):

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    upload_id = db.Column(db.Integer, db.ForeignKey('tags.id'),
                          nullable=False)
    tags_id = db.Column(db.Integer, db.ForeignKey('uploads.id'),
                        nullable=False)

    def __init__(self, ui, ti):
        self.upload_id = ui
        self.tags_id = ti
