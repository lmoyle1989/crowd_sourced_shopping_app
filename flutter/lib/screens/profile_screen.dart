import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'deals_response_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;
  bool loading = true;

  void _getUserInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final int _userId = sharedPreferences.getInt('user_id') as int;
    final http.Response apiResponse = await http.get(Uri.parse(
        DealsResponseScreen.herokuUri + "/users/" + _userId.toString()));
    user = User.fromJSON(apiResponse.body);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: SizedBox(
                      child: (_getUserRankTitle(user.uploadsCount as int)!
                          .userRankIcon as Icon),
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 50),
                  _getUserRankTitle(user.uploadsCount as int)!.userRankText
                      as Text,
                  const SizedBox(height: 50),
                  Text("Upload Count: ${user.uploadsCount}"),
                  const SizedBox(height: 50),
                  Text("User Name: ${user.firstName} ${user.lastName}"),
                  const SizedBox(height: 50),
                  Text("Account Email: ${user.email}"),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class UserRankTitle {
  Icon? userRankIcon;
  Text? userRankText;

  UserRankTitle();
}

UserRankTitle? _getUserRankTitle(int uploadCount) {
  UserRankTitle ret = UserRankTitle();
  if (uploadCount < 10) {
    ret.userRankIcon = const Icon(
      Icons.bedroom_baby,
      color: Colors.blue,
      size: 90,
    );
    ret.userRankText = const Text(
      "BRAND NEW SHOPPER",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  } else if (uploadCount < 50 && uploadCount >= 10) {
    ret.userRankIcon = const Icon(
      Icons.shopping_bag_outlined,
      color: Colors.green,
      size: 90,
    );
    ret.userRankText = const Text(
      "NOVICE SHOPPER",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  } else if (uploadCount < 100 && uploadCount >= 50) {
    ret.userRankIcon = const Icon(
      Icons.shopping_cart,
      color: Colors.yellow,
      size: 90,
    );
    ret.userRankText = const Text(
      "EXPERIENCED SHOPPER",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.yellow,
      ),
    );
  } else if (uploadCount < 500 && uploadCount >= 100) {
    ret.userRankIcon = const Icon(
      Icons.shopping_cart_outlined,
      color: Colors.orange,
      size: 90,
    );
    ret.userRankText = const Text(
      "BEAVER SHOPPER",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
    );
  } else {
    ret.userRankIcon = const Icon(
      Icons.local_fire_department,
      color: Colors.red,
      size: 90,
    );
    ret.userRankText = const Text(
      "ULTRA ELITE EXTREME SHOPPER",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }
  return ret;
}

User testUser = User(
    email: "testemail@gmail.com",
    firstName: "Test",
    lastName: "User",
    uploadsCount: 501);
