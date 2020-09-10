# ###############################################
#####                LOGIN                  #####
#################################################
from flask import Blueprint, render_template, request, flash, redirect, url_for, json, current_app, jsonify
import jwt
from datetime import datetime, timedelta, date
from mmdeasycashapi.users.utils import save_avartar, send_msg, get_user_role, get_local_time, token_required
from mmdeasycashapi.mobile.utils import get_user_float
from flask_login import login_user, logout_user, current_user, login_required
import random
import os

from mmdeasycashapi import app, db, bcrypt, mail
from flask_mail import Message

users = Blueprint('users', __name__)


@users.route('/')
@users.route('/index')
@users.route('/login', methods=['POST'])
def login():
    user_data = request.get_json()
    required_fields = ["phone", "password"]

    if not user_data:
        response = {
            'status': 'error',
            "message": "Missing data"
        }
        return jsonify(response), 400

    if not all(field in user_data.keys() for field in required_fields):
        response = {
            'status': 'error',
            "message": "Required Fields Missing"
        }
        return jsonify(response), 400

    user = User.query.filter_by(phone=user_data['phone']).first()

    if user:
        if bcrypt.check_password_hash(user.password, user_data['password']):
            login_user(user)
            user_role = Role.query.filter_by(id=int(user.roles)).first().name

            token = jwt.encode({
                'user': user.id,
                'exp': get_local_time(datetime.utcnow()) + timedelta(days=30)
            }, app.config['SECRET_KEY'])

            # Incase of any redirect for forced login, find the next requested page
            if user.first_time_login:
                # Generate the token and redirect the user there to reset the password
                reset_token = user.get_reset_token()

                response = {
                    'status': 'success',
                    'message': 'Welcome to MMDEasyCash. Please Consider Changing your password!',
                    'reset_token': reset_token,
                    'userId': user.id,
                    'role': user_role,
                    'avartar': '/static/avartar/person.jpg'
                }
                return jsonify(response)

            elif current_user.account_status == False:

                response = {
                    'status': 'error',
                    'message': 'Your account has been deactivated. Please Contact the Administrator to enable it'
                }
                logout_user()

                return jsonify(response)

            else:
                # All User pins
                user_pins = UserPin.query.filter_by(user_id=user.id).first()
                user_pins_json = json.loads(user_pins.all_pins)
                # Get today's date
                date_today = datetime.date(get_local_time(datetime.utcnow()))

                all_day_pins = user_pins_json.keys()
                rand_pin = ''

                if str(date_today) not in all_day_pins:
                    # Randomly Generate the user PIN - Send to user on account creation
                    # Update the user pins
                    rand_pin = gen_pass()
                    title = 'User PIN'
                    msg = f"""
                    Hello {user.firstname},

                    Your pin for today's transactions was successfully updated and
                    sent to {user.phone}.\n\n
                    """

                    user_pins_json.update(
                        {str(date_today): bcrypt.generate_password_hash(rand_pin).decode('utf-8')})
                    user_pins.all_pins = json.dumps(user_pins_json)

                    notification = Notification(
                        user_id=user.id, title=title, msg_date=datetime.utcnow(), msg=msg)
                    db.session.add(notification)

                    try:
                        db.session.commit()
                    except Exception as e:
                        response = {
                            'status': 'error',
                            'message': 'Something Went Wrong'
                        }
                        return jsonify(response)

                response = {
                    'status': 'success',
                    'message': 'Login Successful',
                    'token': token.decode('utf-8'),
                    'userId': user.id,
                    'firstname': user.firstname,
                    'lastname': user.lastname,
                    'email': user.email,
                    'role': user_role,
                    'pin': rand_pin,
                    'avartar': '/static/avartar/'+user.avartar
                }
                return jsonify(response)
        else:
            response = {
                'status': 'error',
                'message': 'Invalid Password'
            }
            return jsonify(response)
    else:
        response = {
            'status': 'error',
            'message': f'No user with phone number {user_data["phone"]}. Please Register or Check your Login credentials'
        }
        return jsonify(response)


@users.route('/logout', methods=['POST'])
@login_required
def logout():
    logout_user()
    response = {
        'status': 'success',
        'message': 'Log out successful'
    }
    return jsonify(response)


# ###############################################
#####               PROFILE                 #####
#################################################


# @users.route('/profile/<userid>', methods=['GET', 'PUT'])
# # @token_required
# # @login_required
# def profile(userid):

#     current_user = User.query.filter_by(id=int(userid)).first()
#     if not current_user:
#         response = {
#             'status': 'error',
#             'message': 'No such user in the system'
#         }
#         return jsonify(response)

#     if request.method == 'PUT':
#         user_data = request.get_json()
#         required_fields = ["firstname", 'lastname',
#                            'email', 'nextofkeen', 'avartar']

#         if not user_data:
#             response = {
#                 'status': 'error',
#                 "message": "Missing data"
#             }
#             return jsonify(response)

#         if current_user:
#             if 'firstname' in user_data.keys():
#                 current_user.firstname = user_data['firstname']
#             if 'lastname' in user_data.keys():
#                 current_user.lastname = user_data['lastname']
#             if 'nextofkeen' in user_data.keys():
#                 current_user.nextofkeen = user_data['nextofkeen']
#             if 'email' in user_data.keys():
#                 current_user.email = user_data['email']
#             if 'avartar' in user_data.keys():
#                 avartar_file = save_avartar(user_data['avartar'])

#                 # Get previous user avatar and delete it
#                 if current_user.avartar != 'person.jpg':
#                     old_avartar_path = os.path.join(
#                         current_app.root_path, 'static/avartar', current_user.avartar)
#                     os.remove(f'{old_avartar_path}')

#                 current_user.avartar = avartar_file

#             try:
#                 db.session.commit()
#                 avartar_url = url_for(
#                     'static', filename=f'avartar/{current_user.avartar}')
#                 response = {
#                     'status': 'success',
#                     'message': 'Your Profile has been updated',
#                     'data': {'id': current_user.id, 'email': current_user.email, 'firstname': current_user.firstname, 'lastname': current_user.lastname, 'avartar': avartar_url}
#                 }

#                 return jsonify(response)

#             except Exception as e:
#                 response = {
#                     'status': 'error',
#                     'message': 'Profile Update Failed'
#                 }
#                 return jsonify(response)

#         else:
#             response = {
#                 'status': 'error',
#                 'message': f"Error Fetching User with id={user_data['userid']}"
#             }
#             return jsonify(response)
#     else:
#         avartar_url = url_for(
#             'static', filename=f'avartar/{current_user.avartar}')
#         response = {
#             'status': 'success',
#             'message': 'Profile Fetched Successfully',
#             'data': {'id': current_user.id, 'userId': current_user.userId, 'email': current_user.email, 'firstname': current_user.firstname, 'lastname': current_user.lastname, 'avartar': avartar_url, 'phone': current_user.phone}
#         }

#         return jsonify(response)

# # ###############################################
# #####               SETTING                 #####
# #################################################


# @users.route('/settings', methods=['GET', 'POST'])
# # @login_required
# def settings():
#     notifcations = Notification.query.filter_by(
#         user_id=current_user.id, read_status=False).all()

#     avartar_url = url_for('static', filename=f'avartar/{current_user.avartar}')
#     return render_template('settings.html', title='Settings', avartar_url=avartar_url, user_notification=notifcations)


# # @users.route('/user/<action>/<user_id>')
# # @login_required
# # @roles_required('admin')
# # def change_user_status(action, user_id):
# #     # get the current logged in user and return the json data of the information
# #     users = User.query.all()

# #     # return jsonify(results)
# #     return render_template('users.html', title='Users', users=users)

# @users.route('/user/status', methods=['POST'])
# # @login_required
# # @roles_required('admin','agent')
# def change_user_status():
#     user_data = request.get_json()
#     if not user:
#         response = {
#             'status': 'error',
#             'message': 'Missing Data'
#         }
#         return jsonify(response)
#     required_fields = ['action', 'user_id', 'current_user']

#     if not all([field in user_data.keys() for field in required_fields]):
#         response = {
#             'status': 'error',
#             'message': 'Required Data Missing'
#         }
#         return jsonify(response)

#     # Get the current admin pin
#     # user_pin = UserPin.query.filter_by(user_id=int(user_data['current_user'])).first().all_pins
#     # user_pin_today = json.loads(user_pin)[str(datetime.date(datetime.utcnow()))]

#     user = User.query.filter_by(id=int(user_data['user_id'])).first()

#     user_role = get_user_role()[0]
#     action = user_data['action']

#     if action == 'deactivate':
#         user.account_status = False
#     else:
#         user.account_status = True

#     try:
#         db.session.commit()
#         if user_role == 'admin':
#             response = {
#                 'status': 'success',
#                 'message': f'Account has successfully been {action.title()}d'
#             }
#             return jsonify(response)
#         else:
#             logout_user()
#             response = {
#                 'status': 'success',
#                 'message': f'Account has successfully been {action.title()}d'
#             }
#             return jsonify(response)
#     except Exception as e:
#         response = {
#             'status': 'error',
#             'message': 'Error Changing Account Status'
#         }
#         return jsonify(response)


# @users.route('/users/<level>', methods=['GET'])
# # @login_required
# # @roles_required('admin')
# def get_users(level):
#     # get the current logged in user and return the json data of the information
#     users = []
#     if level == 'all':
#         users = User.query.all()
#     elif level == 'agents':
#         role = Role.query.filter_by(name='agent').first()
#         if role:
#             users = User.query.filter_by(roles=str(role.id)).all()

#     message = 'There are currently no users in the system'
#     data = []
#     avartar_url = url_for('static', filename=f'avartar/')

#     if len(users) > 0:
#         message = 'Users Successfully Fetched'
#         data = [{'id': user.id, 'avartar': f'{avartar_url}{user.avartar}', 'firstname': user.firstname,
#                  'lastname': user.lastname, 'phone': user.phone, 'email': user.email} for user in users]

#     response = {
#         'status': 'success',
#         'message': message,
#         'data': data
#     }
#     return jsonify(response)