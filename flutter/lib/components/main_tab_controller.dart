import 'package:flutter/material.dart';
import 'package:crowd_sourced_shopping_app/screens/live_feed_screen.dart';
import 'package:crowd_sourced_shopping_app/screens/shopping_lists_screen.dart';
import 'package:crowd_sourced_shopping_app/screens/upload_screen.dart';

class MainTabController extends StatelessWidget {
  static const List<Tab> _tabs = [
    Tab(icon: Icon(Icons.rss_feed)),
    Tab(icon: Icon(Icons.list)),
    Tab(icon: Icon(Icons.upload)),
  ];

  final List<Widget> _screens = [
    const LiveFeedScreen(),
    const ShoppingListsScreen(),
    const UploadScreen(),
  ];

  MainTabController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Crowd Sourced Shopping App"),
          bottom: TabBar(
            tabs: _tabs,
            indicator: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(10)),
          ),
          centerTitle: true,
        ),
        body: TabBarView(
          children: _screens,
        ),
      ),
    );
  }
}
