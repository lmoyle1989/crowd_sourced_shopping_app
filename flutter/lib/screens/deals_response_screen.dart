import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/models/shopping_list.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crowd_sourced_shopping_app/components/get_location.dart';
import 'package:crowd_sourced_shopping_app/models/api_response.dart';

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
        /*
        _postShoppingList().then(
          (response) {
            jsonResponse = response;
            bestStores = _storesFromJSON(jsonResponse.body);
            setState(() {
              loading = false;
            });
          },
        );
        */

        bestStores = _storesFromJSON(jsonEncode(testResponse));
        setState(() {
          loading = false;
        });
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
            return Center(
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: FractionallySizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Best Store Found!",
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(bestStores[0].storeName!,
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 20),
                      Text(bestStores[0].storeAddress!,
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 20),
                      Text("${bestStores[0].matchRank!}% Tag Match",
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 20),
                      Text(
                          "Total Cost: \$${bestStores[0].averagePrice! * currentList.items.length}")
                    ],
                  ),
                  widthFactor: 0.75,
                  heightFactor: 0.75,
                ),
              ),
            );
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

var testResponse = [
  {
    'store_address': '1234 test street',
    'store_name': 'safeway',
    'average_price': 5.0,
    'match_rank': 75.0,
    'days_since_upload': 1.0
  },
  {
    'store_address': '1235 test street',
    'store_name': 'safeway2',
    'average_price': 6.0,
    'match_rank': 77.0,
    'days_since_upload': 2.0
  }
];
