import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/components/main_tab_controller.dart';
import 'package:crowd_sourced_shopping_app/screens/login_screen.dart';
import 'package:crowd_sourced_shopping_app/screens/register_screen.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final routes = {
    LoginPage.routeName: (context) => LoginPage(),
    RegisterPage.routeName: (context) => RegisterPage(),
    MainTabController.routeName: (context) => MainTabController(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Crowd Sourced Shopping App",
      theme: ThemeData.dark(),
      routes: routes,
    );
  }
}
