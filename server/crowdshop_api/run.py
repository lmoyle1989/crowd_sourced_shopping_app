import os
from tests.load_test_data import load_stores_data, drop_all
from crowdshop.app import init_app

app = init_app(config_type=os.getenv('FLASK_ENV', 'development'))

if __name__ == '__main__':
    with app.app_context():
        load_stores_data()
    app.run(host='localhost', port=8080, debug=True)

