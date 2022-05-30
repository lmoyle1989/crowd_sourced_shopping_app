import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_sourced_shopping_app/models/shopping_list.dart';
import 'package:crowd_sourced_shopping_app/screens/shopping_list_crud_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingListsScreen extends StatefulWidget {
  const ShoppingListsScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingListsScreen> createState() => _ShoppingListsScreenState();
}

class _ShoppingListsScreenState extends State<ShoppingListsScreen> {
  late CollectionReference _shoppingLists;
  bool loading = true;

  void _getUserFirebaseCollection() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    int _userId = sharedPreferences.getInt('user_id') as int;
    FirebaseFirestore.instance
        .collection('users/')
        .doc(_userId.toString())
        .set({}, SetOptions(merge: true));
    CollectionReference userLists = FirebaseFirestore.instance
        .collection('users/' + _userId.toString() + '/shopping_lists');
    setState(() {
      _shoppingLists = userLists;
      loading = false;
    });
  }

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
          builder: (context) => ShoppingListCrudScreen(
            documentSnapshot: null,
            shoppingLists: _shoppingLists,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShoppingListCrudScreen(
            documentSnapshot: documentSnapshot,
            shoppingLists: _shoppingLists,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserFirebaseCollection();
    setState(() {});
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
      body: Builder(builder: (BuildContext context) {
        if (loading) {
          return const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Column(
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
                        child: Icon(
                          Icons.shopping_bag,
                          size: 100,
                          color: Colors.grey,
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
                          onTap: () =>
                              _pushCrudScreen(context, documentSnapshot),
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
        );
      }),
    );
  }
}
