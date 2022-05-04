import json

from flask import Blueprint, request
from sqlalchemy import and_, cast, String
from db.stores import Stores

bp = Blueprint('stores', __name__, url_prefix='/stores')


@bp.route('', methods=["GET"])
def get_store_by_name():

    name = request.args["name"]
    lat = request.args["latitude"]
    lon = request.args["longitude"]
    store_query = Stores.query.filter(
        and_(
            Stores.name.like(name+'%'),
            cast(Stores.latitude, String(120)).like(lat+'%'),
            cast(Stores.longitude, String(120)).like(lon+'%')
        )).all()
    json_list = [item.get_dict_repr() for item in
                 store_query]
    data = json.dumps(json_list)
    return data, 200



