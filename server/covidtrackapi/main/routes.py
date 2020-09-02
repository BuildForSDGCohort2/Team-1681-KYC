from flask import Blueprint, request, jsonify
from flask_login import login_required
from covidtrackapi.models import Faq, Notification, UserContact
from covidtrackapi import db
from covidtrackapi.users.utils import check_userdata

main = Blueprint('main', __name__)


# ###############################################
#####               COVIDS                  #####
#################################################
@main.route('/contacts/add', methods=['POST'])
# @roles_required('admin')
def new_contact():
    contact_user_data = request.get_json()

    new_contact_fields = ["carrier", "client",
                          "source", 'destination', 'starttime']

    check_userdata(contact_user_data, new_contact_fields)

    faq = Faq.query.filter_by(question=contact_user_data['question']).first()

    if not faq:
        try:
            new_journey = UserContact(
                question=contact_user_data['question'], answer=contact_user_data['answer'])
            db.session.add(new_journey)
            db.session.commit()
            response = {
                'status': 'success',
                "message": "Contact Successfully Added",
                "data": {
                    "question": contact_user_data['question'],
                    "answer": contact_user_data['answer']
                }
            }
            return jsonify(response), 201

        except Exception:
            response = {
                'status': 'error',
                "message": "Contact Addition Failed"
            }
            return jsonify(response), 500

    else:
        response = {
            'status': 'error',
            "message": "Contact already exists"
        }
        return jsonify(response), 200


@main.route('/usercontacts', methods=['POST'])
# @roles_required('admin')
def contacts():
    user_contacts_data = request.get_json()

    required_field = ["user_nin"]

    check_userdata(user_contacts_data, required_field)

    contact_client1 = UserContact.query.filter_by(
        carriernin=user_contacts_data['user_nin']).all()
    contact_client2 = UserContact.query.filter_by(
        clientnin=user_contacts_data['user_nin']).all()

    contacts = contact_client1 + contact_client2
    data = []
    message = 'There are currently no contacts Made'

    if len(contacts) > 0:
        data = [{contact.id, contact.contactcode, contact.client1, contact.client2, contact.contacttype,
                 contact.source, contact.destination, contact.contacttime} for contact in contacts]
        message = 'Contacts Fetched Successfully!'

    response = {
        'status': 'success',
        'message': message,
        'data': data
    }
    return jsonify(response)

# ###############################################
#####                 FAQs                  #####
#################################################


@main.route('/faqs', methods=['POST', 'GET'])
# @roles_required('admin')
def faqs():
    if request.method == 'POST':
        faq_data = request.get_json()

        new_faq_fields = ["question", "answer"]

        check_userdata(faq_data, new_faq_fields)

        faq = Faq.query.filter_by(question=faq_data['question']).first()

        if not faq:
            try:
                new_faq = Faq(
                    question=faq_data['question'], answer=faq_data['answer'])
                db.session.add(new_faq)
                db.session.commit()
                response = {
                    'status': 'success',
                    "message": "FAQ Successfully Added",
                    "data": {
                        "question": faq_data['question'],
                        "answer": faq_data['answer']
                    }
                }
                return jsonify(response), 201

            except Exception:
                response = {
                    'status': 'error',
                    "message": "FAQ Addition Failed"
                }
                return jsonify(response), 500

        else:
            response = {
                'status': 'error',
                "message": "Frequently Asked question already exists"
            }
            return jsonify(response), 200

    faqs = Faq.query.all()
    data = []
    message = 'There are currently no FAQs in the system'

    if len(faqs) > 0:
        data = [{faq.id, faq.question, faq.answer} for faq in faqs]
        message = 'FAQs Fetched Successfully!'

    response = {
        'status': 'success',
        'message': message,
        'data': data
    }
    return jsonify(response)


@main.route('/faqs/<int:faq_id>/update', methods=['PUT'])
# @login_required
# @roles_required('admin')
def update_faq(faq_id):

    updated_faq_data = request.get_json()

    updated_faq_fields = ["question", "answer"]

    check_userdata(updated_faq_data, updated_faq_fields)

    faq = Faq.query.get_or_404(faq_id)

    if faq:
        if faq.question != updated_faq_data['question'] or faq.answer != updated_faq_data['answer']:

            faq.question = updated_faq_data['question']
            faq.answer = updated_faq_data['answer']

            try:
                db.session.commit()
                response = {
                    'status': 'success',
                    "message": "FAQ Successfully updated",
                    "data": {
                        "question": updated_faq_data['question'],
                        "answer": updated_faq_data['answer']
                    }
                }
                return jsonify(response), 201

            except Exception:
                response = {
                    'status': 'error',
                    "message": "FAQ Update Failed"
                }
                return jsonify(response), 500

        else:
            response = {
                'status': 'error',
                "message": "Information provided is the same as the one in the system. No update made"
            }

            return jsonify(response), 200

    else:
        response = {
            'status': 'error',
            "message": "There is no Frequently Asked Question with id = {}".format(faq_id)
        }

        return jsonify(response), 400


@main.route('/faqs/<int:faq_id>/delete', methods=['DELETE'])
@login_required
# @roles_required('admin')
def del_faq(faq_id):

    faq = Faq.query.get_or_404(faq_id)
    if faq:
        try:
            db.session.delete(faq)
            db.session.commit()

            response = {
                'status': 'success',
                "message": "FAQ Removed Successfully"
            }
            return jsonify(response), 201

        except Exception:
            response = {
                'status': 'error',
                "message": "Failed to delete the FAQ"
            }

            return jsonify(response), 500

    else:
        response = {
            'status': 'error',
            "message": f"Frequently Asked Question with id={faq_id} was not found in the system"
        }

        return jsonify(response), 400


# ###############################################
#####            NOTIFICATIONS              #####
#################################################

@main.route('/notifications/<userid>', methods=['GET'])
# @login_required
# @token_required
def notification(userid):
    notifcations = Notification.query.filter_by(user_id=int(
        userid)).order_by(Notification.msg_date.desc()).all()

    message = 'You Currently Have No Notifications'
    data = []
    unread = 0

    if len(notifcations) > 0:
        user_notifications = [
            notification for notifcation in notifcations if notifcation.read_status == False]
        unread = len(user_notifications)
        message = 'User Notifications Successfully Fetched'
        data = [{'date': notification.msg_date, 'msg': notification.msg, 'read status': bool(
            notification.read_status), 'title': notification.title, 'sender': notification.sender} for notification in notifcations]

    response = {
        'status': 'success',
        'message': message,
        'count': unread,
        'data': data
    }
    return jsonify(response)


@main.route('/notifications', methods=['POST'])
@login_required
def change_read_status():

    notification_data = request.get_json()
    notification_fields = ["notification_id"]

    check_userdata(notification_data, notification_fields)

    notification_id = int(notification_data['notification_id'])

    notifcation = Notification.query.filter_by(id=notification_id).first()
    changed = False

    message = ''
    status = ''

    # Set the notofocation status as read if not already read
    if not notifcation.read_status:
        notifcation.read_status = True

        try:
            db.session.commit()
            changed = True
            status = 'success'
            message = 'Read Successfully'
        except Exception as e:
            status = 'error',
            message = 'Read Status Change Failed. '+str(e)

    response = {
        'status': status,
        'message': message,
        'data': changed
    }

    return jsonify(response)
