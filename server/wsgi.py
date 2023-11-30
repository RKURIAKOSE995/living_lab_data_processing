'''

'''


__author__ = "Ethan Bellmer"
__version__ = "0.1"


from flask import Flask
import datetime
import json
from flask import request
from werkzeug.serving import WSGIRequestHandler
from iMonnit.monnit import monnit_webhook
from flask_basicauth import BasicAuth
from flask_httpauth import HTTPTokenAuth
from decouple import config

app = Flask(__name__)
app.config['BASIC_AUTH_USERNAME'] = config('MONNIT_WEBHOOK_UNAME')
app.config['BASIC_AUTH_PASSWORD'] = config('MONNIT_WEBHOOK_PWD')

basic_auth = BasicAuth(app)

tokens=config('X_DOWNLINK_APIKEY')


#	Authent Functions
def verify_token(token):
	if token in tokens:
		return tokens[token]


@app.route('/')
@app.route('/index')
def index():
    return "Hello, World!"


@app.route('/imonnit', methods=['POST'])
@basic_auth.required
def process_monnit():
	monnit_webhook()


#	TTN Listener
@app.route('/ttn/uplink/messages', methods=['POST'])
def TTN_UPLINK_MESSAGE():
	print('')
	headers = request.headers
	auth = headers.get("X-Api-Key")
	if auth == verify_token(auth):
		status_code = Flask.Response(status=200)

		print("TTN Uplink Message JSON Recieved...")
		requestJSON = json.load(request.json)
		jsonDump(requestJSON, '/ttn/ttn_' + str(datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")) + '.json')
	else:
		status_code = Flask.Response(status=401)
	return status_code


#	TTN Webhook Testing for other messages
@app.route('/', methods=['POST'])
def root():
	headers = request.headers
	auth = headers.get("X-Api-Key")
	if auth == verify_token(auth):
		status_code = Flask.Response(status=200)

		print("Root JSON Recieved...")
		requestJSON = json.load(request.json)
		jsonDump(requestJSON, 'root_' + str(datetime.datetime.now()) + '.json') # Disabled for testing as it doesn't work on Windows
	else:
		status_code = Flask.Response(status=401)
	return status_code
