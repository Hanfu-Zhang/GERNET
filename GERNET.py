import os
from app import create_app
from app.models import *
# from gevent import pywsgi
from flask_cors import CORS

app = create_app(os.getenv('FLASK_CONFIG') or 'default')

CORS(app, supports_credentials=True)


@app.shell_context_processor
def make_shell_context():
    return dict(db=db)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9005, debug=True)
