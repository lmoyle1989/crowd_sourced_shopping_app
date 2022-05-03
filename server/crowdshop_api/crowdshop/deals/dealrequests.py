# data access object for deals
from geopy import distance
from db.stores import Stores
from sqlalchemy import or_, and_


class DealInquirer(object):

    def __init__(self, deals, location:tuple):
        self.deals = deals
        self.stores = []
        self.points = []
        self.store_location = location

    def get_perimeter(self, radius=3):
        for i in range(0, 360, 30):
            self.points.append(
                distance.distance(miles=radius).destination(self.store_location,
                                                            bearing=i))

    def get_all_stores(self):
        Stores.query.filter(
            or_(
            and_(Stores.longitude.between(point[0], self.store_location[0],
                                          Stores.latitude.between(point[1],
                                                                  self.store_location[1]) ) for point in self.points
                )
            )
        )

