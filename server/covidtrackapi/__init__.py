"""Package managing the entire app
It initializes the parameters needed for running the server and the vrious routes

    """

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_login import LoginManager
from flask_mail import Mail
import os


app = Flask(__name__)

# Start the DB
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get(
    'SQLALCHEMY_DATABASE_URI')
# app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY')

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True

# Mail Configurations
app.config['MAIL_SERVER'] = 'smtp.googlemail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = os.environ.get('MAIL_USERNAME')
app.config['MAIL_PASSWORD'] = os.environ.get('MAIL_PASSWORD')

mail = Mail(app)
db = SQLAlchemy(app)

# Instantiate the encryption model
bcrypt = Bcrypt(app)
# Add the login manager

loginmanager = LoginManager(app)
loginmanager.login_view = 'users.login'
loginmanager.login_message_category = 'danger'

# Import the routes here to avoid circilar imports
from covidtrackapi.users.routes import users
from covidtrackapi.main.routes import main
from covidtrackapi.roles.routes import roles


app.register_blueprint(users)
app.register_blueprint(main)
app.register_blueprint(roles)
