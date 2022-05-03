import pytest
from crowdshop.app import init_app
from tests.load_test_data import load_stores_data, drop_all


@pytest.fixture()
def app():
    app = init_app('development')
    app.config.update(
        {
            "TESTING": True
        }
    )
    with app.app_context():
        load_stores_data()

    yield app

    with app.app_context():
        drop_all()


@pytest.fixture
def client(app):
    return app.test_client()


@pytest.fixture
def t_runner(app):
    return app.test_cli_runner()
