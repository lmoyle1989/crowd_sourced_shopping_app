from db import db


TagsUploads = db.Table('TagsUploads', db.metadata,
                       db.Column('uploads_id', db.ForeignKey('uploads.id'),
                                 primary_key=True),
                       db.Column('tags_id', db.ForeignKey('tags.id'),
                                 primary_key=True))
