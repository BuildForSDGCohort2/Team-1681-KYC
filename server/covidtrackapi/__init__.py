from flask import Flask
# from flask_login import current_user, login_required
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_login import LoginManager
from flask_migrate import Migrate
from covidtrackapi.config import Config
from flask_material import Material
from flask_mail import Mail
import os
# from flask import current_app


app = Flask(__name__)

# Start the DB
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///covidtracker.db'
# app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
app.config['SECRET_KEY'] = 'Thisiscovidtrackingsecretkey'

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True

# Mail Configurations
app.config['MAIL_SERVER'] = 'smtp.googlemail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = ''
app.config['MAIL_PASSWORD'] = ''

mail = Mail(app)

db = SQLAlchemy(app)
Material(app)

# Instantiate the encryption model
bcrypt = Bcrypt(app)
# Add the login manager

# Configure a secret key
# app.config.from_object(Config)

# SECRET_KEY = os.getenv('SECRET_KEY')
# Configure the database
# SQLALCHEMY_DATABASE_URI = os.getenv('SQLALCHEMY_DATABASE_URI')

# perform configurations


loginmanager = LoginManager(app)
loginmanager.login_view = 'users.login'
loginmanager.login_message_category = 'danger'

migrate = Migrate(app, db)

# Import the routes here to avoid circilar imports
from covidtrackapi.users.routes import users
from covidtrackapi.main.routes import main
from covidtrackapi.roles.routes import roles


app.register_blueprint(users)
app.register_blueprint(main)
app.register_blueprint(roles)
