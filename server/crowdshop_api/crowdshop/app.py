import os
from flask import Flask
from user_access import user
from config import config
from db import db


def init_app(config_type=None):
    app = Flask(__name__)

    if config_type == 'production':
        app.config.from_object(config.Production)
    else:
        app.config.from_object(config.Development)

    reg_blueprint(app)

    # initialize database with current app instance
    db.init_app(app)
    # create all tables
    db.create_all()

    return app


def reg_blueprint(app):
    app.register_blueprint(user.bp)



