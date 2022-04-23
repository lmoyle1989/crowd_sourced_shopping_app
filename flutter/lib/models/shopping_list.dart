class ShoppingList {
  String title;
  List<String>? items;

  ShoppingList({
    required this.title,
    this.items,
  });

  factory ShoppingList.fromJSON(Map<String, dynamic> json) {
    return ShoppingList(
      title: json['title'],
      items: List<String>.from(json['items']),
    );
  }
}
