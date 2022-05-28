from flask import Blueprint, request, jsonify
from crowdshop.deals.dealrequests import DealInquirer

bp = Blueprint('deals', __name__, url_prefix='/deals')


@bp.route('', methods=["POST"])
def find_deal():
    data = request.json
    deals = DealInquirer(data["tags"], user_location=data["location"])
    best_deal = deals.get_best_deal()

    return jsonify(best_deal), 200

