from flask import Blueprint, request, url_for
from crowdshop.auth import jwt_required

bp = Blueprint('users', __name__, url_prefix='/users')


@bp.route('', methods=['POST'])
def user_register():
    pass


@bp.route('/<user_id>/upload', methods=['GET', 'POST'])
@jwt_required()
def user_upload(user_id):
    pass


