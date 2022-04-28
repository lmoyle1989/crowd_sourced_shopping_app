import os


class MainConfig(object):
    SECRET_KEY = os.getenv('SECRET_KEY', 'secret')
    JWT_SECRET = os.getenv('JWT_SECRET', 'testing')
    SQLALCHEMY_TRACK_MODIFICATIONS = 'False'


class Development(MainConfig):
    SQLALCHEMY_DATABASE_URI = os.environ.get('SQLALCHEMY_DATABASE_URI')


class Production(MainConfig):
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        'SQLALCHEMY_DATABASE_URI').replace('postgres://', 'postgresql://')
