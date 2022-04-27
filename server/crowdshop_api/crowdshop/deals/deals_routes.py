from flask import Blueprint, request

bp = Blueprint('deals', __name__, url_prefix='/deals')


@bp.route('', methods=["GET"])
def find_deal():
    # query to get all uploads with specific tags according to shopping list
    # based on a 25 mile radius of stores lat lon
    # userlat - storelat
    # userlon - storelon
    # -- assuming every store has every item --
    # create Deal, Product and Store instances
    # add Store to Deal, add Products to Stores
    # calculate price total for each Deal
    # calculate total number of products on sale
    # calculate average days old
    # prioritize -- cheapest, newest, most on sale
    pass

