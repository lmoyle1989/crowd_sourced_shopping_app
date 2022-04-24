import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_sourced_shopping_app/models/shopping_list.dart';
import 'package:flutter/material.dart';

class ShoppingListCrudScreen extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot;

  const ShoppingListCrudScreen({
    Key? key,
    this.documentSnapshot,
  }) : super(key: key);

  @override
  State<ShoppingListCrudScreen> createState() => _ShoppingListCrudScreenState();
}

class _ShoppingListCrudScreenState extends State<ShoppingListCrudScreen> {
  late ShoppingList shoppingList;

  @override
  void initState() {
    super.initState();
    if (widget.documentSnapshot != null) {
      shoppingList = ShoppingList.fromSnapshot(
          widget.documentSnapshot as DocumentSnapshot);
    } else {
      shoppingList = ShoppingList(title: "New Shopping List", items: []);
    }
  }

  void _deleteItem(ShoppingList shoppingList, int index) {
    shoppingList.deleteItem(index);
    setState(() {});
  }

  void _addItem(ShoppingList shoppingList, String item) {
    shoppingList.addItem(item);
    setState(() {});
  }

  void _saveChanges() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Shopping List"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [Text("Title: " + shoppingList.title!)],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: shoppingList.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(shoppingList.items[index]),
                  trailing: IconButton(
                    onPressed: () => _deleteItem(shoppingList, index),
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
