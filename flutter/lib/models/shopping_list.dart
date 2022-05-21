import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList {
  String? listID;
  String? title;
  List<String> items;
  double? latitude;
  double? longitude;

  ShoppingList({
    this.listID,
    this.title,
    this.items = const [],
  });

  factory ShoppingList.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return ShoppingList(
      listID: documentSnapshot.id,
      title: documentSnapshot['title'],
      items: List<String>.from(documentSnapshot['items']),
    );
  }

  Map toMapForUpload() {
    var json = <String, dynamic>{};
    List<List<String>> itemsMatrix = [];
    for (String itemString in items) {
      List<String> tagArray = itemString.split(' ');
      tagArray = tagArray.map((tag) => tag.toLowerCase()).toList();
      itemsMatrix.add(tagArray);
    }
    json["title"] = title;
    json["items"] = itemsMatrix;
    json["latitude"] = latitude;
    json["longitude"] = longitude;
    return json;
  }

  void deleteItem(int index) {
    if (items.isNotEmpty) {
      items.removeAt(index);
    }
  }

  void addItem(String item) {
    items.add(item);
  }

  void changeTitle(String title) {
    this.title = title;
  }
}
