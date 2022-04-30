import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_sourced_shopping_app/models/shopping_list.dart';
import 'package:crowd_sourced_shopping_app/screens/shopping_list_crud_screen.dart';

class ShoppingListsScreen extends StatelessWidget {
  ShoppingListsScreen({Key? key}) : super(key: key);

  final CollectionReference _shoppingLists =
      FirebaseFirestore.instance.collection('shopping_lists');

  Future<void> _deleteList(String listID) async {
    await _shoppingLists.doc(listID).delete();
  }

  void _pushCrudScreen(
    BuildContext context,
    DocumentSnapshot? documentSnapshot,
  ) {
    if (documentSnapshot == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShoppingListCrudScreen(documentSnapshot: null),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ShoppingListCrudScreen(documentSnapshot: documentSnapshot),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pushCrudScreen(context, null),
        child: const Text(
          "New List",
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          const ListTile(
            title: Text(
              "YOUR SHOPPING LISTS",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _shoppingLists.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (!streamSnapshot.hasData) {
                  return const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  if (streamSnapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Icon(Icons.shopping_bag),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      ShoppingList shoppingList =
                          ShoppingList.fromSnapshot(documentSnapshot);
                      return ListTile(
                        onTap: () => _pushCrudScreen(context, documentSnapshot),
                        title: Text(shoppingList.title! +
                            "  (" +
                            shoppingList.items.length.toString() +
                            ")"),
                        trailing: IconButton(
                          onPressed: () => _deleteList(shoppingList.listID!),
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    }),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
