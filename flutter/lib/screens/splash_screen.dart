import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'package:crowd_sourced_shopping_app/components/main_tab_controller.dart';

int? usersId;

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    validate().whenComplete(() async {
      Timer(
        Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => usersId == null ? LoginPage() :  MainTabController()))
    );
    });
  }

  Future validate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var getId = preferences.getInt('user_id');
    setState(() {
      usersId = getId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[850],
      child: Icon(Icons.shopping_cart_outlined, size: MediaQuery.of(context).size.width * 0.4)
    );
  }
}