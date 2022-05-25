import datetime
from flask import Blueprint, Flask, request, session
import json
from db import db
from db.users import Users
from db.user_comments import UserComments
from server.crowdshop_api.crowdshop.user_access.user_routes import user_register

com_route = Blueprint('com_route', __name__)

@com_route.route('/comments', methods=['GET'])
def print_comments():
    """Gets the list of comments in the UserComments tables and joins with User names"""

    # Write a join query to get the first and last name of the user and the comment associated with their user_id and the date it was written on
    get_comments = session.query(UserComments).join(Users).filter(Users.first_name, Users.last_name, UserComments.comment, UserComments.date).order_by(UserComments.date)
    
    # create an empty list and add all of the json data from query above into it
    comment_list = []
    for item in get_comments:
        comment_list.append(dict(item))
    return json.dumps(comment_list, skipkeys=True, indent=6, default=str)

@com_route('/new-comment')
def create_comment():
    """Creates a new UserComment class based on query string parameters"""
    user_id = request.args.get('user_id')
    cr_comment = request.args.get('cr_comment')

    if user_id and cr_comment:
        new_comment = UserComments(
            user_id = user_id,
            cr_comment = cr_comment,
            date = datetime.datetime.now()
        )
        db.session.add(new_comment)
        db.session.commit()
    
    get_all_comments = UserComments.query.all()

    # same purpose as list in route above
    insert_list = []
    for comm in get_all_comments:
        insert_list.append(dict(comm))
    return json.dumps(insert_list, indent=2, default=str)
