import 'package:crowd_sourced_shopping_app/models/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/components/item_tile.dart';

class ShoppingListCrudScreen extends StatelessWidget {
  const ShoppingListCrudScreen({
    Key? key,
    required this.shoppingList,
  }) : super(key: key);

  final ShoppingList shoppingList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.title),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: shoppingList.items!.length,
        itemBuilder: (context, index) {
          return ItemTile(
            item: shoppingList.items![index],
          );
        },
      ),
    );
  }
}
