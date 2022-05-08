import json

from flask import Blueprint, request
from sqlalchemy import and_, cast, String
from db.stores import Stores

bp = Blueprint('stores', __name__, url_prefix='/stores')


@bp.route('', methods=["GET"])
def get_store_by_name():

    name = request.args.get("name", "")
    lat = request.args["latitude"]
    lon = request.args["longitude"]

    # - exists
    if lat.find('-') != -1:
        # trim to include -
        lat = lat[:4]
    else:
        lat = lat[:3]
    if lon.find('-') != -1:
        # trim to include -
        lon = lon[:5]
    else:
        lon = lon[:4]
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



