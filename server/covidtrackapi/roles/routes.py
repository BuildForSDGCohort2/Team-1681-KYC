# ###############################################
#####              USER ROLE                #####
#################################################
from flask import Blueprint, request, jsonify
from covidtrackapi import db
from covidtrackapi.models import Role
from covidtrackapi.users.utils import check_userdata

roles = Blueprint('roles', __name__)


# Adding a new role
@roles.route('/roles', methods=['GET', 'POST'])
# @login_required
# @roles_required('admin')
def role():

    if request.method == 'POST':
        new_role_data = request.get_json()
        new_role_fields = ["name", "description"]

        check_userdata(new_role_data, new_role_fields)

        role_name = new_role_data['name']
        description = new_role_data['description']

        role = Role.query.filter_by(name=role_name.lower()).first()
        if role:
            response = {
                'status': 'error',
                'message': 'User Role Already Exists'
            }
            return jsonify(response)

        else:
            new_role = Role(name=role_name.title(),
                            description=description)
            db.session.add(new_role)
            try:
                db.session.commit()
                response = {
                    'status': 'success',
                    'id': new_role.id,
                    'message': 'New Role Added Successfully'
                }
                return jsonify(response)
            except Exception as e:
                response = {
                    'status': 'error',
                    'message': 'Error Adding User Role. '+str(e)
                }
                return jsonify(response)
    else:
        roles = Role.query.all()

        message = 'There are currently no roles available'
        data = []

        if len(roles) > 0:
            message = 'Roles Fetched Successfully'
            data = [{'id': role.id, 'name': role.name.title(), 'description': role.description, 'roleId': role.roleId}
                    for role in roles]

        response = {
            'status': 'success',
            'message': message,
            'data': data
        }

        return jsonify(response)


# Delete an added role
@roles.route('/role/<int:role_id>/delete', methods=['DELETE'])
# @login_required
# @roles_required('admin')
def del_role(role_id):
    role_item = Role.query.get_or_404(role_id)

    if role_item:
        db.session.delete(role_item)

        try:
            db.session.commit()

            response = {
                'status': 'success',
                'message': 'User Role Deleted Successfully'
            }
            return jsonify(response)

        except Exception as e:
            response = {
                'status': 'error',
                'message': 'Error Deleteing User Role ' + str(e)
            }
            return jsonify(response)

    else:
        response = {
            'status': 'error',
            'message': 'No such role found'
        }
        return jsonify(response)

# Updating the list of roles


@roles.route('/role/<int:role_id>/update', methods=['PUT'])
# @login_required
# @roles_required('admin')
def update_role(role_id):

    updated_role_data = request.get_json()
    role_required_fields = ["name", "description"]
    check_userdata(updated_role_data, role_required_fields)

    role = Role.query.filter_by(id=role_id).first()

    if not role:
        response = {
            "status": "error",
            "message": "There is no Role with id {}".format(role_id)
        }

        return jsonify(response)

    if role.name == updated_role_data['name'] and role.description == updated_role_data['description']:
        response = {
            "status": "error",
            "message": "No Changes Made"
        }

        return jsonify(response)

    role.name = updated_role_data['name'].lower()
    role.description = updated_role_data['description']

    try:
        db.session.commit()

        response = {
            'status': 'success',
            'message': 'Role Updated Successfully'
        }
        return jsonify(response)

    except Exception as e:
        response = {
            'status': 'error',
            'message': 'Error Updating Role. ' + str(e)
        }
        return jsonify(response)
