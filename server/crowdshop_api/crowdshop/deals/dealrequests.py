# data access object for deals
from geopy import distance
from db.stores import Stores
from db.uploads import Uploads
from db.tags import Tags
from db.tags_uploads import TagsUploads

from sqlalchemy import or_, and_


class DealInquirer(object):

    def __init__(self, items, user_location: tuple):
        self.items = items
        self.deals = []
        self.items_uploads = []
        self.points = []
        self.user_location = user_location

    def get_perimeter(self, radius=3):
        """ get location points around perimeter of current region """
        for i in range(0, 360, 30):
            self.points.append(
                distance.distance(
                    miles=radius).destination(self.user_location,
                                              bearing=i))

    def find_items(self):
        """ query to get all uploads with specified items within region """

        tag_or = [or_(*[Tags.tag.contains(x) for x in item]) for item in
                   self.items]
        self.items_uploads = Stores.query \
            .join(Uploads, isouter=True) \
            .join(TagsUploads, isouter=True) \
            .join(Tags, isouter=True) \
            .filter(*tag_or)\
            .all()

