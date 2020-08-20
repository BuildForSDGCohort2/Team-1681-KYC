import os


class Config:
    SECRET_KEY = os.getenv('SECRET_KEY')
    # SECRET_KEY = os.environ.get('SECRET_KEY')
    # print(SECRET_KEY)

    # Configure the database
    # SQLALCHEMY_DATABASE_URI = os.getenv('SQLALCHEMY_DATABASE_URI')
    SQLALCHEMY_DATABASE_URI = 'sqlite:///covidtracker.db'
    # print(SQLALCHEMY_DATABASE_URI)
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JSONIFY_PRETTYPRINT_REGULAR = True
