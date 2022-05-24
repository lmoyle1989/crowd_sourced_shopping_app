from datetime import datetime


class Product(object):

    def __init__(self, price, sale, date):
        self.tags = []
        self.price = price
        self.is_sale = sale
        self.last_updated = date
        self.age = 0

    def calc_date_diff(self):
        """ days from upload """
        now = datetime.today()
        self.age = abs((self.last_updated - now).days)


class Store(object):

    def __init__(self, address, name):
        self.address = address
        self.name = name
        self.products = {}
        self.value = 0
        self.all_tags = set()
        self.match_percent = 0

    def calc_match_percent(self, match_with):
        # match all tags at store with expected tags
        for k, p in self.products.items():
            for t in p.tags:
                self.all_tags.add(t)
        q1 = len(match_with)
        q2 = len(match_with.intersection(self.all_tags))
        self.match_percent = q2/q1

    def __lt__(self, other):
        return self.match_percent < other.match_percent

    def __gt__(self, other):
        return self.match_percent > other.match_percent

    def __ge__(self, other):
        return self.match_percent >= other.match_percent

    def __le__(self, other):
        return self.match_percent <= other.match_percent


class Deal(object):

    def __init__(self, store_address, store_name):
        self.store = Store(store_address, store_name)
        self.price_total = 0
        self.total_on_sale = 0
        self.average_days_old = 0
        self.average_price = 0

    def calculate_average_days(self):
        product_quantity = len(self.store.products)
        self.average_days_old = (sum(self.store.products[p].age for p in
                                     self.store.products))/product_quantity

    def calculate_total_sale(self):
        for pid, product in self.store.products.items():
            if product.is_sale:
                self.total_on_sale += 1

    def average_total_price(self):
        self.average_price = self.price_total/len(self.store.products)

    def __lt__(self, other):
        """
        checks instance priority
        :return: higher priority, return False, otherwise True
        """
        # match percent is high, price is low
        if self.store >= other.store and self.average_price <= \
                other.average_price:
            return False
        # match percent is high, price is high
        elif self.store >= other.store and self.average_price >= \
                other.average_price:
            # upload is newer
            if self.average_days_old < other.average_days_old:
                return False
            else:
                return True
        else:
            return True

