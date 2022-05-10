import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crowd_sourced_shopping_app/utilities/theme_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  State<UserDrawer> createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.16,
          //   child: DrawerHeader(
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text('Name',
          //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
          //             ),
          //             IconButton(
          //               icon: const Icon(Icons.close),
          //               onPressed: () {
          //                 Navigator.pop(context);
          //               },
          //             ),
          //           ]
          //         ),
          //         Text('Rank'),
          //         Text('Number of uploads')
          //       ],
          //     )
          //   )
          // ),
          Consumer<ThemeSettings>(
            builder: (context, value, child) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                value: value.darkTheme,
                onChanged: (newVal) {
                  value.changeTheme();
                },
              );
            }
          ),
          ListTile(
            title: const Text('Log Out'),
            onTap: () async {
              final SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.remove('user_id');
              preferences.remove('user_token');
              Navigator.pushNamed(context, 'login');
            },
          )
        ]
      )
    );
  }
}