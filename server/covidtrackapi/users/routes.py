# ###############################################
#####                LOGIN                  #####
#################################################
from flask import Blueprint, request, json, current_app, jsonify, url_for
import jwt
from datetime import datetime, timedelta
from covidtrackapi.models import User, Role, Notification, Journey
from covidtrackapi.users.utils import is_leap_year, save_avartar, get_user_role, get_local_time, token_required
from flask_login import login_user, logout_user, current_user, login_required
import os

from covidtrackapi import app, db, bcrypt, mail
from flask_mail import Message

users = Blueprint('users', __name__)


@users.route('/')
@users.route('/index')
@users.route('/login', methods=['POST'])
def login():
    user_login_data = request.get_json()
    required_login_fields = ["phone", "password"]

    check_userdata(user_login_data, required_login_fields)

    user = User.query.filter_by(phone=user_login_data['phone']).first()

    if user:
        if bcrypt.check_password_hash(user.password, user_login_data['password']):
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
                    'message': 'Welcome to Covid-19 Tracker!',
                    'firstime': user.first_time_login,
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
                try:
                    db.session.commit()
                    response = {
                        'status': 'success',
                        'message': 'Login Successful',
                        'token': token.decode('utf-8'),
                        'userId': user.id,
                        'firstname': user.firstname,
                        'lastname': user.lastname,
                        'email': user.email,
                        'role': user_role,
                        'avartar': '/static/avartar/'+user.avartar
                    }
                    return jsonify(response)

                except Exception as e:
                    response = {
                        'status': 'error',
                        'message': 'Something Went Wrong. '+str(e)
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
            'message': 'No user with phone number {}. Please Register or Check your Login credentials'.format(user_login_data["phone"])
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
#####              ADD USER                 #####
#################################################

@users.route('/users/register', methods=['POST'])
def create_user():
    # take the user to the signin page
    user_registration_data = request.get_json()
    required_fields = ["phone", "password", "email", "firstname",
                       "lastname", "country", "state", "street", "avartar"]

    check_userdata(user_registration_data, required_fields)

    if len(user_registration_data['phone']) != 10:
        response = {
            'status': 'error',
            "message": "Invalid Phone Number"
        }
        return jsonify(response), 400

    # Check if the user exist

    existing_user = User.query.filter_by(
        phone=user_registration_data['phone']).first()

    if existing_user:
        response = {
            'status': 'error',
            'message': f"User with {user_registration_data['phone']} already exists"
        }

        return jsonify(response)

    givenRole = Role.query.filter_by(name='user').first()

    phone = user_registration_data['phone']
    password = user_registration_data['password']
    email = user_registration_data['email']
    firstname = user_registration_data['firstname']
    lastname = user_registration_data['lastname']
    country = user_registration_data['country']
    state = user_registration_data['state']
    street = user_registration_data['street']

    pass_hashed = bcrypt.generate_password_hash(password).decode('utf-8')

    user = User(phone=phone, password=pass_hashed, roles=str(givenRole.id),
                firstname=firstname, lastname=lastname, email=email, avartar=avartar)

    db.session.add(user)

    # Combine the line and operator names
    try:
        db.session.commit()

        # Randomly Generate the user PIN - Send to user on account creation
        title = 'Welcome'
        msg = """
        Hello There!,

        Welcome to the Covid-19 Contact Tracer.
        Please Complete Your profile for easy identification.
        For any inquiries, check the FAQs or post a comment.
        """
        user_info = UserInfo(userid=user.userId,
                             country=country, state=state, street=street)

        notification = Notification(
            user_id=user.id, title=title, msg_date=datetime.utcnow(), msg=msg)

        db.session.add_all((notification, user_info))
        db.session.commit()

        # Send Password to the user
        message = f"Your Account Was Successfully Created."
        # response = send_msg(message, phone)

        response = {
            "status": "success",
            "message": message
        }

        return jsonify(response)
    except Exception as e:
        response = {
            "status": "error",
            "message": 'Error Creating User. '+str(e)
        }
        return jsonify(response)


def send_reset_email(user):
    token = user.get_reset_token()

    msg = Message('Password Reset Request',
                  sender='noreply@covid19tracker.com',
                  recipients=[user.email])

    msg.body = f"""Click on the link below to reset your password
    {url_for('users.reset_password', token=token, _external=True)}

    If you did not make this request, please ignore this message!
                """
    mail.send(msg)


@users.route('/reset_password', methods=['POST'])
def reset_request():
    password_reset_data = request.get_json()
    password_reset_fields = ["email"]

    check_userdata(password_reset_data, password_reset_fields)

    user = User.query.filter_by(email=password_reset_data['email']).first()

    if user:
        send_reset_email(user)

        response = {
            'status': 'success',
            'message': 'Password reset email was sent to your email address.'
        }
        return jsonify(response)

    else:
        response = {
            'status': 'error',
            'message': 'No user with this email available'
        }
        return jsonify(response)


@users.route('/reset', methods=['POST'])
def reset_password():
    reset_data = request.get_json()
    if not reset_data:
        response = {
            'status': 'error',
            'message': 'Missing Data'
        }
        return jsonify(response)

    if 'token' not in reset_data.keys():
        response = {
            'status': 'error',
            'message': 'Missing Token'
        }
        return jsonify(response)
    if 'password' not in reset_data.keys():
        response = {
            'status': 'error',
            'message': 'Input New Password'
        }
        return jsonify(response)

    token = reset_data['token']

    user = User.verify_reset_token(token)

    if user is None:
        response = {
            'status': 'error',
            'message': 'An invalid or Expired Token'
        }

        return jsonify(response)

    hashed_password = bcrypt.generate_password_hash(reset_data['password'])
    user.password = hashed_password
    if user.first_time_login:
        user.first_time_login = False

    db.session.commit()

    response = {
        'status': 'success',
        'message': 'Your password has successfully been updated. You can now login'
    }

    return jsonify(response)

# ###############################################
#####               PROFILE                 #####
#################################################


@users.route('/profile/<userid>', methods=['GET', 'PUT'])
# @token_required
# @login_required
def profile(userid):

    current_user = User.query.filter_by(id=int(userid)).first()
    if not current_user:
        response = {
            'status': 'error',
            'message': 'No such user in the system'
        }
        return jsonify(response)

    if request.method == 'PUT':
        profile_data = request.get_json()

        if not profile_data:
            response = {
                'status': 'error',
                "message": "Missing data"
            }
            return jsonify(response), 400

        if 'nin' not in profile_data.keys():
            response = {
                'status': 'error',
                "message": "Please Submit Your NIN"
            }
            return jsonify(response), 400

        if current_user:
            if 'firstname' in profile_data.keys():
                current_user.firstname = profile_data['firstname']
            if 'lastname' in profile_data.keys():
                current_user.lastname = profile_data['lastname']
            if 'nin' in profile_data.keys():
                current_user.nin = profile_data['nin']
            if 'email' in profile_data.keys():
                current_user.email = profile_data['email']
            if 'avartar' in profile_data.keys():
                avartar_file = save_avartar(profile_data['avartar'])

            # Get previous user avatar and delete it
            if current_user.avartar != 'person.jpg':
                old_avartar_path = os.path.join(
                    current_app.root_path, 'static/avartar', current_user.avartar)
                os.remove(f'{old_avartar_path}')

            current_user.avartar = avartar_file

            try:
                db.session.commit()
                avartar_url = url_for(
                    'static', filename=f'avartar/{current_user.avartar}')
                response = {
                    'status': 'success',
                    'message': 'Your Profile has been updated',
                    'data': {'id': current_user.id, 'email': current_user.email, 'firstname': current_user.firstname, 'lastname': current_user.lastname, 'avartar': avartar_url, 'nin': current_user.nin}
                }

                return jsonify(response)

            except Exception as e:
                response = {
                    'status': 'error',
                    'message': 'Profile Update Failed'
                }
                return jsonify(response)

        else:
            response = {
                'status': 'error',
                'message': f"Error Fetching User with id={user_data['userid']}"
            }
            return jsonify(response)
    else:
        avartar_url = url_for(
            'static', filename=f'avartar/{current_user.avartar}')
        response = {
            'status': 'success',
            'message': 'Profile Fetched Successfully',
            'data': {'id': current_user.id, 'email': current_user.email, 'firstname': current_user.firstname, 'lastname': current_user.lastname, 'avartar': avartar_url, 'phone': current_user.phone}
        }

        return jsonify(response)


# ###############################################
#####               STATUS                  #####
#################################################
@users.route('/user/status', methods=['POST'])
# @login_required
# @roles_required('admin','agent')
def change_user_status():
    user_status_data = request.get_json()
    user_status_fields = ['action', 'user_id', 'current_user']

    check_userdata(user_status_data, user_status_fields)

    user = User.query.filter_by(id=int(user_status_data['user_id'])).first()

    # user_role = get_user_role()[0]
    action = user_status_data['action']

    if action == 'infected':
        user.infected = True
    else:
        user.account_status = False

    try:
        db.session.commit()
        response = {
            'status': 'success',
            'message': f'User has successfully been Tagged {action.title()}d'
        }
        return jsonify(response)

    except Exception as e:
        response = {
            'status': 'error',
            'message': 'User Tagging Failed'
        }
        return jsonify(response)


@users.route('/contacts/add', methods=['POST'])
# @login_required
# @roles_required('admin')
def add_contacts():
    new_contact_data = request.get_json()
    required_contact_fields = ['userid', 'users']

    check_userdata(new_contact_data, required_contact_fields)

    rider = Journey.query.filter_by(rider=new_contact_data['userid']).all()
    client = Journey.query.filter_by(client=new_contact_data['userid']).all()

    all_user_contacts = rider + client
    existing_contacts = [contact.journeycode for contact in all_user_contacts]

    user_contacts = new_contact_data['users']

    to_update = [
        contact_to_add for contact_to_add in user_contacts if user_contacts['journeycode'] not in existing_contacts]

    # Make an upload of this
    for upload in to_update:
        user_journey = Journey(journeycode=upload['journeycode'], rider=upload['rider'], client=upload['client'],
                               pickuptime=upload['pickuptime'], source=upload['source'], destination=upload['destination'])
        db.session.add(user_journey)

    try:
        db.session.commit()

        response = {
            'status': 'success',
            'message': 'Pending Contacts Uploaded Successfully'
        }

        return jsonify(response)
    except Exception as e:
        response = {
            'status': 'error',
            'message': 'Error Performing Updates. '+str(e)
        }
        return jsonify(response)


@users.route('/contacts', methods=['POST'])
# @login_required
# @roles_required('admin')
def get_contacts():
    client_data = request.get_json()
    required_client_fields = ['userid']

    check_userdata(client_data, required_client_fields)

    client1 = Journey.query.filter_by(client1=client_data['userid']).all()
    client2 = Journey.query.filter_by(client2=client_data['userid']).all()

    all_user_contacts = client1 + client2

    downloads = []
    message = 'There are currently no users in the system'

    if len(all_user_contacts) > 0:
        message = 'Contacts Fetched Successfully!'
        downloads = [{'client1': contact.client1, 'contactcode': contact.contactcode, 'client': contact.client2,
                      'source': contact.source, 'destination': contact.destination, 'contacttime': contact.contacttime, 'uploaded': contact.uploaded} for contact in all_user_contacts]

    response = {
        'status': 'success',
        'message': message,
        'data': downloads
    }
    return jsonify(response)
