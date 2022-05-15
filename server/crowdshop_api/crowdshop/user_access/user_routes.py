from crypt import methods
from flask import Blueprint, jsonify, request, url_for, current_app
from crowdshop.auth import jwt_required
from db.users import Users
from db import db
from crowdshop.utils.response import generate_response
import json

bp = Blueprint('users', __name__, url_prefix='/users')


@bp.route('', methods=['POST'])
def user_register():
    data = request.json
    try:
        email = data['email']
        password = data['password']
        fn = data['fn']
        ln = data['ln']
    except KeyError:
        return generate_response(400, {"message": "missing input"})

    user = Users.query.filter_by(email=email).first()

    if user:
        return generate_response(409)
    else:
        user = Users(fn, ln, password, email)
        db.session.add(user)
        db.session.commit()
    return generate_response(201, data={"user_id": user.id})


@bp.route('/<user_id>/uploads', methods=['GET', 'POST'])
@jwt_required()
def user_upload(user_id):
    return 'jwt auth working', 200

@bp.route('/<user_id>', methods=['GET'])
def user_profile(user_id):
    user_query = Users.query.filter_by(id=user_id).first()
    user_json = user_query.get_dict_repr()
    data = json.dumps(user_json)
    return data, 200
