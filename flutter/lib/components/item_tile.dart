import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({Key? key, required this.item}) : super(key: key);

  final String item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item),
      trailing: const Icon(Icons.delete),
    );
  }
}
