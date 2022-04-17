import os

from crowdshop.app import init_app

app = init_app(config_type=os.environ.get('FLASK_ENV'))

if __name__ == '__main__':
    app.run(host='localhost', port=8080, debug=True)
