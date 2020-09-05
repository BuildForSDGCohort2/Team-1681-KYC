from covidtrackapi import db, loginmanager, app
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer
from flask_login import UserMixin
import uuid


def generate_key():
    random_key = uuid.uuid4().urn
    gen_key = random_key[9:]

    return gen_key


@loginmanager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    userId = db.Column(db.String, unique=True,
                       nullable=False, default=generate_key)
    phone = db.Column(db.String(11), unique=True, nullable=False)
    firstname = db.Column(db.String(30))
    lastname = db.Column(db.String(30))
    email = db.Column(db.String(120))
    nin = db.Column(db.String(120))
    roles = db.Column(db.String, nullable=False)
    offlinecode = db.Column(db.String, nullable=False, )
    avartar = db.Column(db.String, default='person.jpg', nullable=False)
    password = db.Column(db.String(60), nullable=False)
    is_active = db.Column(db.Boolean, nullable=False, default=1)
    first_time_login = db.Column(db.Boolean, nullable=False, default=1)
    account_status = db.Column(db.Boolean, nullable=False, default=1)

    def get_reset_token(self, expires_sec=1800):
        serial = Serializer(app.config['SECRET_KEY'], expires_sec)
        return serial.dumps({'user_id': self.id}).decode('utf-8')

    def verify_reset_token(token):
        serial = Serializer(app.config['SECRET_KEY'])
        try:
            user_id = serial.loads(token)['user_id']
        except Exception:
            return None

        return User.query.get(user_id)

    verify_reset_token = staticmethod(verify_reset_token)

    def __repr__(self):
        return f"User('{self.id}', '{self.offlinecode}', '{self.userId}','{self.phone}','{self.firstname}','{self.lastname}', '{self.email}', '{self.avartar}', '{self.roles}', '{self.is_active}', '{self.first_time_login}')"


class UserInfo(db.Model):
    __tablename__ = 'user_info'
    id = db.Column(db.Integer, primary_key=True)
    userId = db.Column(db.String, unique=True, nullable=False,)
    country = db.Column(db.String(11), unique=True, nullable=False)
    state = db.Column(db.String(30))
    street = db.Column(db.String(30))

    def __repr__(self):
        return f"UserInfo('{self.id}', '{self.userId}','{self.country}','{self.state}','{self.street}')"


class UserContact(db.Model):
    __tablename__ = 'user_contact'
    id = db.Column(db.Integer, primary_key=True)
    contactcode = db.Column(db.String, unique=True, nullable=False)
    client1 = db.Column(db.String, nullable=False)
    client2 = db.Column(db.String, nullable=False)
    contacttime = db.Column(db.DateTime, nullable=False)
    contacttype = db.Column(db.String, nullable=False)
    source = db.Column(db.String, nullable=False)
    destination = db.Column(db.String, nullable=False)
    uploaded = db.Column(db.Boolean, nullable=False, default=True)
    infected = db.Column(db.Boolean, nullable=False, default=False)

    def __repr__(self):
        return f"UserContact('{self.id}','{self.journeycode}','{self.client1}','{self.client2}', '{self.contacttime}', '{self.source}', '{self.destination}', '{self.uploaded}', '{self.infected}', '{self.contacttype}')"


# Define the Role data-model
class Role(db.Model):
    __tablename__ = 'role'
    id = db.Column(db.Integer, primary_key=True)
    roleId = db.Column(db.String, unique=True,
                       nullable=False, default=generate_key)
    name = db.Column(db.String(50), unique=True, nullable=False)
    description = db.Column(db.String, nullable=False)

    def __repr__(self):
        return f"Role('{self.id}','{self.name}', '{self.description}', '{self.roleId}')"

# Define the UserRoles association table


class Notification(db.Model):
    __tablename__ = 'notification'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey(
        'user.id', ondelete='CASCADE'), nullable=False)
    msg_date = db.Column(db.DateTime, nullable=False)
    title = db.Column(db.String, nullable=False)
    msg = db.Column(db.String, nullable=False)
    sender = db.Column(db.String, nullable=False, default='Covid-19 Support')
    read_status = db.Column(db.Integer, nullable=False, default=0)

    def __repr__(self):
        return f"Notification('{self.id}','{self.user_id}','{self.msg_date}','{self.title}','{self.msg}','{self.sender}','{self.read_status}')"


class Faq(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    question = db.Column(db.String, unique=True, nullable=False)
    answer = db.Column(db.Text, nullable=False)

    def __repr__(self):
        return f"Faq('{self.id}','{self.question}','{self.answer}')"
