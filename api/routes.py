from flask import Flask
from flask_cors import CORS
from auth import auth_routes
from alerts import alerts_routes
from chat import chat_routes

app = Flask(__name__)
CORS(app)

app.register_blueprint(auth_routes)
app.register_blueprint(alerts_routes)
app.register_blueprint(chat_routes)