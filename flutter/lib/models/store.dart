class Store {
  int id;
  String name;
  String address;

  Store({required this.id, required this.address, required this.name});

  factory Store.fromJson(Map<String, dynamic> store) {
    return Store(
        address: store["address"], id: store["id"], name: store["name"]);
  }
}
