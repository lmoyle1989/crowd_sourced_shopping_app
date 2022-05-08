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
  LocationData? locationData;
  var locationService = Location();

  Future getLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    return locationData;
  }

  void setListLocation() async {
    LocationData locationData = await getLocation();
    currentList.latitude = locationData.latitude;
    currentList.longitude = locationData.longitude;
    setState(() {});
  }

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

  void testJSON() {
    print(jsonEncode(currentList.toMap()));
  }

  @override
  void initState() {
    super.initState();
    currentList = widget.shoppingList;
    setListLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finding Deals"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("test post"),
          onPressed: () => testPost(),
        ),
      ),
    );
  }
}
