import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/models/shopping_list.dart';

class DealsResponseScreen extends StatefulWidget {
  const DealsResponseScreen({Key? key, required this.shoppingList})
      : super(key: key);

  final ShoppingList shoppingList;

  @override
  State<DealsResponseScreen> createState() => _DealsResponseScreenState();
}

class _DealsResponseScreenState extends State<DealsResponseScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
