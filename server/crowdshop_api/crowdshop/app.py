from flask import Flask
from crowdshop.user_access import user_routes
from crowdshop.auth import login_routes, jwt
from config import config
from db import db
from db.users import Users
from db.stores import Stores
from db.uploads import Uploads
from db.tags import Tags
from db.tags_uploads import TagsUploads
from deals import deals_routes


def init_app(config_type=None):
    app = Flask(__name__)

    if config_type == 'production':
        app.config.from_object(config.Production)
    else:
        app.config.from_object(config.Development)

    reg_blueprint(app)

    # initialize database with current app instance
    db.init_app(app)
    # initialize jwt instance with current app
    jwt.init_app(app)
    # create all tables
    with app.app_context():
        db.create_all()

    return app


def reg_blueprint(app):
    app.register_blueprint(user_routes.bp)
    app.register_blueprint(login_routes.bp)
    app.register_blueprint(deals_routes.bp)


