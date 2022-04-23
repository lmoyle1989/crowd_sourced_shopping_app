import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/models/shopping_list.dart';
import 'package:crowd_sourced_shopping_app/screens/shopping_list_crud_screen.dart';

class ShoppingListTile extends StatelessWidget {
  const ShoppingListTile({
    Key? key,
    required this.shoppingList,
  }) : super(key: key);

  final ShoppingList shoppingList;

  void pushCrudScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShoppingListCrudScreen(
          shoppingList: shoppingList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.shopping_bag),
      title: Text(shoppingList.title),
      trailing: Text(shoppingList.items!.length.toString() + " items"),
      onTap: () {
        pushCrudScreen(context);
      },
    );
  }
}
