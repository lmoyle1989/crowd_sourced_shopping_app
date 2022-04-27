

class Product(object):

    def __init__(self, tags: list, price, sale, date):
        self.tags = tags
        self.price = price
        self.is_sale = sale
        self.last_updated = date


class Store(object):

    def __init__(self, name, lat, lon):
        self.name = name
        self.lat = lat
        self.lon = lon
        self.products = []
