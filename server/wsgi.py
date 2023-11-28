'''

'''


__author__ = "Ethan Bellmer"
__version__ = "0.1"


from flask import Flask
from werkzeug.serving import WSGIRequestHandler
from routes import app_blueprint
from decouple import config
app = Flask(__name__)
app.config['BASIC_AUTH_USERNAME'] = config('MONNIT_WEBHOOK_UNAME')
app.config['BASIC_AUTH_PASSWORD'] = config('MONNIT_WEBHOOK_PWD')
app.register_blueprint(app_blueprint)

