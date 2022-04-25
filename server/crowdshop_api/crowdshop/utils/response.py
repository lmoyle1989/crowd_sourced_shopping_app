from flask import Response
import json


def generate_response(status: int, data: dict = None, error=None,
                      message=None):
    res = Response()

    res.status = status
    if data:
        res.response = json.dumps(data)

    return res
