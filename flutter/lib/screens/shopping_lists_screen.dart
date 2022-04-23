import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_sourced_shopping_app/components/shopping_list_tile.dart';
import 'package:crowd_sourced_shopping_app/models/shopping_list.dart';
import 'package:crowd_sourced_shopping_app/screens/shopping_list_crud_screen.dart';

class ShoppingListsScreen extends StatelessWidget {
  const ShoppingListsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushNewCrudScreen(context);
        },
        child: const Text(
          "New List",
          textAlign: TextAlign.center,
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('shopping_lists').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: ((context, index) {
                ShoppingList shoppingList = ShoppingList.fromJSON(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);
                return ShoppingListTile(
                  shoppingList: shoppingList,
                );
              }),
            );
          }
        },
      ),
    );
  }
}

void pushNewCrudScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ShoppingListCrudScreen(
        shoppingList: ShoppingList(title: "New Shopping List", items: []),
      ),
    ),
  );
}
