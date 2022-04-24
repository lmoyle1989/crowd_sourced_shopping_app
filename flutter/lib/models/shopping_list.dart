import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList {
  String? listID;
  String? title;
  List<String> items;

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

  void deleteItem(int index) {
    if (items.isNotEmpty) {
      items.removeAt(index);
    }
  }

  void addItem(String item) {
    items.add(item);
  }
}
