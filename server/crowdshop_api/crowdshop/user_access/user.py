from flask import (Blueprint, request, url_for)


bp = Blueprint('user', __name__, url_prefix='/user')


@bp.route('/', methods=['GET'])
def user_login():
    pass


@bp.route('/<user_id>/upload', methods=['GET', 'POST'])
def user_upload(user_id):
    pass


