import datetime
from flask import Blueprint, Flask, request, session
import json
from db import db
from db.users import Users
from db.user_comments import UserComments
#from server.crowdshop_api.crowdshop.user_access.user_routes import user_register

bp = Blueprint('comments', __name__, url_prefix='/comments')


@bp.route('', methods=['GET'])
def print_comments():
    """Gets the list of comments in the UserComments tables and joins with User names"""

    # join query combines users and usercomments table based on foreign key
    return_comments = db.session.query(Users.id, Users.first_name, Users.last_name, UserComments.comment, UserComments.date).join(UserComments, UserComments.comment_user_id == Users.id).order_by(UserComments.date.desc()).all()


# create an empty list and add all of the json data from query above into it
    comment_list = []
    for item in return_comments:
        comment_list.append(dict(item))

    return json.dumps(comment_list, skipkeys=True, indent=6, default=str)


@bp.route('', methods=['POST'])
def create_comment():
    """Creates a new UserComment class based on query string parameters"""
    user_id = request.args.get('user_id')
    new_comment = request.args.get('new_comment')

    make_comment = UserComments(
        comment_user_id=user_id,
        comment=new_comment,
        date=datetime.datetime.now()
    )
    db.session.add(make_comment)
    db.session.commit()

    return "Added a new comment"