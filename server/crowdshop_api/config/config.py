import os


class MainConfig(object):
    SECRET_KEY = os.getenv('SECRET_KEY', 'secret')
    JWT_SECRET = os.getenv('JWT_SECRET', 'testing')


class Development(MainConfig):
    SQLALCHEMY_DB_URI = os.environ.get('SQLALCHEMY_DB_URI_DEV')


class Production(MainConfig):
    SQLALCHEMY_DB_URI = os.environ.get('SQLALCHEMY_DB_URI')

