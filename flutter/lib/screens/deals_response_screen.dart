import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/models/shopping_list.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DealsResponseScreen extends StatefulWidget {
  const DealsResponseScreen({Key? key, required this.shoppingList})
      : super(key: key);

  final ShoppingList shoppingList;
  static const herokuUri =
      "https://crowd-sourced-shopping-cs467.herokuapp.com/";

  @override
  State<DealsResponseScreen> createState() => _DealsResponseScreenState();
}

class _DealsResponseScreenState extends State<DealsResponseScreen> {
  late ShoppingList currentList;
  late http.Response apiResponse;
  var locationService = Location();
  bool loading = true;

  Future<LocationData> getLocation() async {
    LocationData locationData;
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          return Future.error('Failed to enable service. Returning.');
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return Future.error(
              'Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      return Future.error('Error: ${e.toString()}, code: ${e.code}');
    }
    return locationData;
  }

  /*
  void testGet() async {
    final http.Response apiResponse =
        await http.get(Uri.parse(DealsResponseScreen.herokuUri));
    print(apiResponse.body);
  }

  void testPost() async {
    final body = jsonEncode(<String, String>{
      'email': 'lmoyle@gmail.com',
      'password': 'test',
    });
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final http.Response apiResponse = await http.post(
        Uri.parse(DealsResponseScreen.herokuUri + "/login"),
        headers: headers,
        body: body);
    print(apiResponse.body);
  }
  */

  Future<http.Response> postShoppingList() async {
    final body = jsonEncode(currentList.toMap());
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
