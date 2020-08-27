from flask import jsonify, request
from functools import wraps
from flask import current_app
from flask_login import current_user
from covidtrackapi.models import Role
import jwt
import os
import string
from PIL import Image
from datetime import datetime
from covidtrackapi import app

# Check for leap_year


def is_leap_year(year):
    if year % 4 == 0:
        if year % 100 == 0:
            if year % 400 == 0:
                return True
            else:
                return False
        else:
            return True
    else:
        return False


# Define the user_roles decorator
def roles_required(*roles):
    def wrapper(f):
        @wraps(f)
        def wrapped(*args, **kwargs):
            count = 0
            for role in roles:
                if role in get_user_role():
                    count += 1

            if count == 0:
                response = {
                    'status': 'error',
                    'message': 'Roles required',
                    'error': 'You have inssufficient permisions'
                }
                return jsonify(response)
            return f(*args, **kwargs)
        return wrapped
    return wrapper


def get_user_role():
    user_roles = [role_id for role_id in list(current_user.roles)]
    all_roles = []
    for role in user_roles:
        all_roles.append(Role.query.filter_by(id=role).first().name)
    return all_roles

# Define the tokens decorator


def token_required(func):
    @wraps(func)
    def wrapped(*args, **kwargs):
        token = request.args.get('token')
        if not token:
            response = {
                'message': 'missing token',
                'status': 'error'
            }
            return jsonify(response), 403

        try:
            jwt.decode(token, app.config['SECRET_KEY'])
        except Exception as e:
            response = {
                'status': 'error',
                'message': 'Invalid or Expired Token. '+str(e)
            }
            return jsonify(response), 403
        return func(*args, **kwargs)
    return wrapped


def save_avartar(user_avartar):
    random_hex = secrets.token_hex(8)
    _, img_ext = os.path.splitext(user_avartar.filename)
    avartar_filename = random_hex + img_ext

    # Get full path where the image is to be saved
    avartar_path = os.path.join(
        current_app.root_path, 'static/avartar', avartar_filename)

    # Resize the image before saving
    img_output_size = (125, 125)

    img = Image.open(user_avartar)
    img.thumbnail(img_output_size)

    img.save(avartar_path)
    return avartar_filename


def gen_pass(code_len=5, pass_type='passcode'):
    pass_values = string.digits
    if pass_type == 'temp_pwd':
        pass_values += string.ascii_letters
    secrets.token_hex(16)[0:code_len]

    return ''.join(secrets.choice(pass_values) for _ in range(code_len))


def get_local_time(utc_time):
        # utc_time_date = datetime.strptime(utc_time, "%Y-%m-%d %H:%M")
        # utc_datetime_timestamp = float(utc_time_date.timestamp())
    utc_datetime_timestamp = float(utc_time.timestamp())

    return datetime.fromtimestamp(utc_datetime_timestamp)


def get_utc_time(local_time):
    # local_time_date = datetime.strptime(local_time, "%Y-%m-%d %H:%M")
    # local_datetime_timestamp = float(local_time_date.timestamp())
    local_datetime_timestamp = float(local_time.timestamp())

    return datetime.utcfromtimestamp(local_datetime_timestamp)
