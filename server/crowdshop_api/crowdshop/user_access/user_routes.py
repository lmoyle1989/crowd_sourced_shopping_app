from flask import Blueprint, request, url_for, current_app
from crowdshop.auth import jwt_required
from db.users import Users
from db.uploads import Uploads
from db import db
from crowdshop.utils.response import generate_response
import json
import datetime

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
    data = request.json
    try:
        store_id = data['store_id']
        price = data['price']
        barcode = data['barcode']
        upload_date = datetime.datetime.fromtimestamp(data['upload_date']//1000)
        on_sale = data['on_sale']
        email = str(data['email'])
    except KeyError:
        return generate_response(400, {"message": "missing input"})

    upload = Uploads(price, upload_date, on_sale, barcode, int(user_id), store_id)
    db.session.add(upload)
    db.session.commit()

    user = Users.query.filter_by(email=email).first()
    user.uploads_count += 1
    db.session.commit()
    return generate_response(201, {"message": "success"})


@bp.route('/<user_id>', methods=['GET'])
def user_profile(user_id):
    user_query = Users.query.filter_by(id=user_id).first()
    user_json = user_query.get_dict_repr()
    data = json.dumps(user_json)
    return data, 200
