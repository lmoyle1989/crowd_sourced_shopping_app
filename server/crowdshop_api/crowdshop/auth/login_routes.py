from flask import Blueprint, request
from db.users import Users
from crowdshop.auth import *

bp = Blueprint('login', __name__, url_prefix='/login')


@bp.route('', methods=["POST"])
def login_user():
    data = request.json
    email = data['email']
    password = data['password']
    user = Users.query.filter_by(email=email, password=password).first()
    if user is None:
        return 'invalid username or password', 404
    else:
        user_token = create_access_token(identity=email)
        return {"user_token": user_token, "user_id": user.id}, 201

