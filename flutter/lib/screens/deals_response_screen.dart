import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/models/shopping_list.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crowd_sourced_shopping_app/components/get_location.dart';

class DealsResponseScreen extends StatefulWidget {
  const DealsResponseScreen({Key? key, required this.shoppingList})
      : super(key: key);

  final ShoppingList shoppingList;
  static const herokuUri = "https://crowd-sourced-shopping-cs467.herokuapp.com";

  @override
  State<DealsResponseScreen> createState() => _DealsResponseScreenState();
}

class _DealsResponseScreenState extends State<DealsResponseScreen> {
  late ShoppingList currentList;
  late http.Response apiResponse;
  var locationService = Location();
  bool loading = true;

  Future<http.Response> postShoppingList() async {
    final body = jsonEncode(currentList.toMapForUpload());
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    http.Response apiResponse = await http.post(
        Uri.parse(DealsResponseScreen.herokuUri + "/deals"),
        headers: headers,
        body: body);
    return apiResponse;
  }

  @override
  void initState() {
    super.initState();
    currentList = widget.shoppingList;
    getLocation().then(
      (loc) {
        currentList.latitude = loc.latitude;
        currentList.longitude = loc.longitude;
        postShoppingList().then(
          (response) {
            apiResponse = response;
            setState(() {
              loading = false;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finding Deals"),
        centerTitle: true,
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (loading) {
            return const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Center(
              child: Text(apiResponse.body),
            );
          }
        },
      ),
    );
  }
}
