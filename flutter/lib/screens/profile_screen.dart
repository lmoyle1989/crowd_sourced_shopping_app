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
                  const Icon(
                    Icons.account_circle,
                    size: 100,
                  ),
                  const SizedBox(height: 50),
                  Text("Shopper Rank: ${user.userRank}"),
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
