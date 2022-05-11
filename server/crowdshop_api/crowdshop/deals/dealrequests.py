# data access object for deals
from geopy import distance
from db.stores import Stores
from db.uploads import Uploads
from db.tags import Tags
from db.tags_uploads import TagsUploads

from sqlalchemy import or_, and_


class DealInquirer(object):

    def __init__(self, items, location:tuple):
        self.items = items
        self.deals = []
        self.items_uploads = []
        self.points = []
        self.store_location = location

    def get_perimeter(self, radius=3):
        """ get location points around perimeter of current region """
        for i in range(0, 360, 30):
            self.points.append(
                distance.distance(
                    miles=radius).destination(self.store_location,
                                                            bearing=i))

    def find_items(self):
        """ query to get all uploads with specified items within region """
        self.items_uploads = Uploads.query\
            .join(Stores)\
            .join(TagsUploads)\
            .join(Tags)\
            .filter(
                or_(
                    and_(
                        Stores.longitude.between(point[0], self.store_location[0],
                        Stores.latitude.between(point[1],
                        self.store_location[1])) for point in self.points
                        )
                    )
            )\
            .filter(
                or_(Tags.tag.like('%'+item+'%') for item in self.items)
            ).all()




