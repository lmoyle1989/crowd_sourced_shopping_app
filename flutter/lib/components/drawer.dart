import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crowd_sourced_shopping_app/utilities/theme_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crowd_sourced_shopping_app/screens/profile_screen.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        Consumer<ThemeSettings>(builder: (context, value, child) {
          return SwitchListTile(
            title: const Text('Dark Mode'),
            value: value.darkTheme,
            onChanged: (newVal) {
              value.changeTheme();
            },
          );
        }),
        ListTile(
          title: const Text("User Profile"),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            ),
          ),
        ),
        ListTile(
          title: const Text('Log Out'),
          onTap: () async {
            final SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.remove('user_id');
            preferences.remove('user_token');
            Navigator.pushNamed(context, 'login');
          },
        ),
      ]),
    );
  }
}
