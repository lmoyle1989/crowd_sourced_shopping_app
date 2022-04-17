import os


class MainConfig(object):
    SECRET_KEY = os.environ.get('SECRET_KEY')


class Development(MainConfig):
    SQLALCHEMY_DB_URI = os.environ.get('SQLALCHEMY_DB_URI_DEV')


class Production(MainConfig):
    SQLALCHEMY_DB_URI = os.environ.get('SQLALCHEMY_DB_URI')

