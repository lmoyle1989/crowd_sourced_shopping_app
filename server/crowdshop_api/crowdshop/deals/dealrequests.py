# data access object for deals
from geopy import distance

import db
from db.stores import Stores
from db.uploads import Uploads
from db.tags import Tags
from db.tags_uploads import TagsUploads
from sqlalchemy import or_, and_
from crowdshop.deals.models import Product, Deal


class DealInquirer(object):

    def __init__(self, items, user_location: tuple):
        self.items = items
        self.deals = {}
        self.sorted_best_id = []
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
        any_tag = []
        for tags in self.items:
            for tag in tags:
                any_tag.append(Tags.tag.contains(tag))

        self.items_uploads = Stores.query \
            .with_entities(
                Stores.id,
                Stores.address,
                Stores.name,
                Uploads.id,
                Uploads.price,
                Uploads.on_sale,
                Uploads.upload_date,
                Uploads.barcode,
                Tags.id,
                Tags.tag)\
            .join(Uploads, isouter=True) \
            .join(TagsUploads, isouter=True) \
            .join(Tags, isouter=True) \
            .filter(or_(*any_tag)) \
            .filter(or_(
                *[or_(
                    (Stores.longitude.between(
                        self.user_location[1], point[1]) &
                     Stores.latitude.between(self.user_location[0], point[0])
                     )
                ) for point in self.points])
            ) \
            .all()

    def structure_stores(self):
        """
        give retrieved data structure using models for priority algorithm
        :return: None
        """
        for upload in self.items_uploads:
            store_id = upload[0]
            store_address = upload[1]
            store_name = upload[2]
            upload_id = upload[3]
            upload_price = upload[4]
            upload_sale = upload[5]
            upload_date = upload[6]
            tag_name = upload[9]

            try:
                self.deals[store_id].store.products[upload_id].tags.append(
                    tag_name)
            except KeyError:
                if not self.deals.get(store_id, None):
                    self.deals[store_id] = Deal(store_address, store_name)

                product = Product(upload_price, bool(upload_sale),
                                  upload_date)
                product.tags.append(tag_name)
                self.deals[store_id].store.products.update({
                    upload_id: product
                })
                self.deals[store_id].price_total += upload_price
        # iterate over all products and calc age and match percent
        self._product_calc()

    def _product_calc(self):
        # create set to compare total unique matches
        set_items = set()
        for tag_list in self.items:
            for tag in tag_list:
                set_items.add(tag)
        for sid, deal in self.deals.items():
            for i, upload in deal.store.products.items():
                upload.calc_date_diff()
            deal.store.calc_match_percent(
                set_items
            )
            # calculate average days old
            deal.calculate_average_days()
            # calculate total sale items in store
            deal.calculate_total_sale()
            # calculate average price of all items in store
            deal.average_total_price()

    def _sort_best(self):
        self.sorted_best_id = sorted(
            self.deals,
            key=lambda x: self.deals[x], reverse=True)

        for k,deal in self.deals.items():
            print(f'\n{k} {deal.store.address}\n'
                  f'price: {deal.average_price}\n'
                  f'match: {deal.store.match_percent}\n'
                  f'age: {deal.average_days_old}')

    def _make_final_object(self):
        best_deals = []
        for i in self.sorted_best_id:
            best_deals.append(
                {
                    "store_address": self.deals[i].store.address,
                    "store_name": self.deals[i].store.name,
                    "average_price": self.deals[i].average_price,
                    "match_rank": self.deals[i].store.match_percent,
                    "days_since_upload": self.deals[i].average_days_old
                }
            )
        return best_deals

    def get_best_deal(self):
        self.get_perimeter()
        self.find_items()
        self.structure_stores()
        self._sort_best()
        return self._make_final_object()






