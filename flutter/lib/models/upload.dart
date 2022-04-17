import 'package:crowd_sourced_shopping_app/models/barcode.dart';

import 'barcode.dart';

class Upload {
  List<String>? tags;
  double? price;
  bool? sale;
  DateTime? date;
  double? latitude;
  double? longitude;
  Barcode? barcode;

  Upload({
    this.tags,
    this.price,
    this.sale,
    this.date,
    this.latitude,
    this.longitude,
    this.barcode,
  });
}
