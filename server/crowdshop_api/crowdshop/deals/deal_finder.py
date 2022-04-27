

class Deal(object):

    def __init__(self, store_id, store):
        self.store_id = store_id
        self.store = store
        self.price_total = 0
        self.total_on_sale = 0
        self.average_days_old = 0

    def calculate_total(self):
        pass

    def calculate_average_days(self):
        pass

