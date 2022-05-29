import os.path

from flask import Flask
from crowdshop.user_access import user_routes
from crowdshop.auth import login_routes, jwt
from crowdshop.comments import comment_routes
from crowdshop.stores import stores_routes
from db import db
from dotenv import load_dotenv
from crowdshop.errors.errors import reroute
from crowdshop.deals import deals_routes
from db.users import Users
from db.user_comments import UserComments
from db.stores import Stores
from db.uploads import Uploads
from db.tags import Tags
from db.tags_uploads import TagsUploads


def init_app(config_type=None):
    app = Flask(__name__)

    if config_type == 'production':
        from config.config import Production
        app.config.from_object(Production)
    else:
        path_to_env = os.path.join(os.path.dirname(__file__), '../.env.dev')
        load_dotenv(path_to_env)
        from config.config import Development
        app.config.from_object(Development)

    reg_blueprint(app)
    reg_errors(app)

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
    app.register_blueprint(comment_routes.bp)
    app.register_blueprint(login_routes.bp)
    app.register_blueprint(deals_routes.bp)
    app.register_blueprint(stores_routes.bp)


def reg_errors(app):
    app.register_error_handler(404, reroute)
