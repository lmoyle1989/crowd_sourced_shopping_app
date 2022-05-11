import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_sourced_shopping_app/models/shopping_list.dart';
import 'package:crowd_sourced_shopping_app/screens/deals_response_screen.dart';

class ShoppingListCrudScreen extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot;

  final CollectionReference shoppingLists;

  ShoppingListCrudScreen({
    Key? key,
    required this.documentSnapshot,
    required this.shoppingLists,
  }) : super(key: key);

  @override
  State<ShoppingListCrudScreen> createState() => _ShoppingListCrudScreenState();
}

class _ShoppingListCrudScreenState extends State<ShoppingListCrudScreen> {
  late ShoppingList shoppingList;

  final TextEditingController _stringEditController = TextEditingController();

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

  void _addItem(ShoppingList shoppingList) {
    _stringEditController.text = '';
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                autofocus: true,
                controller: _stringEditController,
              ),
              ElevatedButton(
                child: const Text('Add Item'),
                onPressed: () {
                  shoppingList.addItem(_stringEditController.text);
                  _stringEditController.text = '';
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editListTitle(ShoppingList shoppingList) {
    _stringEditController.text = shoppingList.title as String;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                autofocus: true,
                controller: _stringEditController,
              ),
              ElevatedButton(
                child: const Text('Ok'),
                onPressed: () {
                  shoppingList.changeTitle(_stringEditController.text);
                  _stringEditController.text = '';
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveChanges(ShoppingList shoppingList) async {
    if (shoppingList.listID != null) {
      await widget.shoppingLists
          .doc(shoppingList.listID)
          .update({'title': shoppingList.title, 'items': shoppingList.items});
    } else {
      await widget.shoppingLists
          .add({'title': shoppingList.title, 'items': shoppingList.items});
    }
    Navigator.of(context).pop();
  }

  void _pushResponseScreen(ShoppingList shoppingList) async {
    if (shoppingList.listID != null) {
      await widget.shoppingLists
          .doc(shoppingList.listID)
          .update({'title': shoppingList.title, 'items': shoppingList.items});
    } else {
      await widget.shoppingLists
          .add({'title': shoppingList.title, 'items': shoppingList.items});
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DealsResponseScreen(shoppingList: shoppingList)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Shopping List"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              shoppingList.title!.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _editListTitle(shoppingList),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _addItem(shoppingList),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: shoppingList.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  visualDensity: const VisualDensity(vertical: -3),
                  title: Text(shoppingList.items[index]),
                  trailing: IconButton(
                    onPressed: () => _deleteItem(shoppingList, index),
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _saveChanges(shoppingList),
                child: const Text("Save Changes"),
              ),
              const SizedBox(
                width: 50,
              ),
              ElevatedButton(
                onPressed: () => _pushResponseScreen(shoppingList),
                child: const Text("Find Best Store"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
