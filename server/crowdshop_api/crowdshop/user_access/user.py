from flask import (Blueprint, request, url_for)


bp = Blueprint('users', __name__, url_prefix='/users')


@bp.route('', methods=['GET'])
def user_login():
    pass


@bp.route('/<user_id>/upload', methods=['GET', 'POST'])
def user_upload(user_id):
    pass


