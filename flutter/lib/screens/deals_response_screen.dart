import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/models/shopping_list.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crowd_sourced_shopping_app/components/get_location.dart';
import 'package:crowd_sourced_shopping_app/models/api_response.dart';
import 'package:crowd_sourced_shopping_app/components/best_store_card.dart';

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
  late http.Response jsonResponse;
  late List<ApiResponse> bestStores = [];
  var locationService = Location();
  bool loading = true;

  Future<http.Response> _postShoppingList() async {
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

  List<ApiResponse> _storesFromJSON(String jsonData) {
    List<dynamic> parsedJSON = jsonDecode(jsonData);
    List<ApiResponse> stores = [];
    for (var store in parsedJSON) {
      stores.add(ApiResponse.fromMap(store));
    }
    return stores;
  }

  @override
  void initState() {
    super.initState();
    currentList = widget.shoppingList;
    getLocation().then(
      (loc) {
        currentList.latitude = loc.latitude;
        currentList.longitude = loc.longitude;
        _postShoppingList().then(
          (response) {
            bestStores = _storesFromJSON(response.body);
            setState(
              () {
                loading = false;
              },
            );
          },
        );
        /*
        bestStores = _storesFromJSON(jsonEncode(testResponse));
        setState(() {
          loading = false;
        });
        */
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(child: Text("Finding best deal...")),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          } else if (bestStores.isNotEmpty) {
            return BestStoreCard(
                store: bestStores[0], itemCount: currentList.items.length);
            /*
            return ListView.builder(
              itemCount: bestStores.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text((bestStores[index].storeName as String) +
                      " - Match: ${bestStores[index].matchRank}%"),
                  subtitle: Text(bestStores[index].storeAddress as String),
                  trailing: Text(
                      '\$${bestStores[index].averagePrice! * currentList.items.length}'),
                );
              },
            );
            */
          } else {
            return const Center(
              child: Text("No Nearby Stores Found"),
            );
          }
        },
      ),
    );
  }
}

/*
var testResponse = [
  {
    'store_address': '450 SW 3rd St, Corvallis, OR 97333',
    'store_name': 'Safeway',
    'average_price': 5.0,
    'match_rank': 83.3,
    'days_since_upload': 1.0
  },
  {
    'store_address': '590 NE Circle Blvd, Corvallis, OR 97330',
    'store_name': 'Safeway',
    'average_price': 6.0,
    'match_rank': 77.0,
    'days_since_upload': 2.0
  }
];
*/
