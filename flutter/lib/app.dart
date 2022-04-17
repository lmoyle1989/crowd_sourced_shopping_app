import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/components/main_tab_controller.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Crowd Sourced Shopping App",
      theme: ThemeData.dark(),
      home:
          MainTabController(), //first page will actually be login/register page
    );
  }
}
