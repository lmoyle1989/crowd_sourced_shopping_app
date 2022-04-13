import os
from flask import Flask
from user_access import user
from config import config


def init_app(config_type=os.environ.get('FLASK_ENV')):
    app = Flask(__name__)

    if config_type == 'production':
        app.config.from_object(config.Production)
    else:
        app.config.from_object(config.Development)

    reg_blueprint(app)

    return app


def reg_blueprint(app):
    app.register_blueprint(user.bp)



