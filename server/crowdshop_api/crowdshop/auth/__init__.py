from flask_jwt_extended import JWTManager
from flask_jwt_extended import jwt_required
from flask_jwt_extended import get_jwt_identity
from flask_jwt_extended import get_current_user
from flask_jwt_extended import create_access_token

jwt = JWTManager()
