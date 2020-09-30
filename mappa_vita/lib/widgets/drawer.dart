import 'package:flutter/material.dart';
import 'package:mappa_vita/screens/about_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            onTap: () {
              Navigator.of(context).pushNamed(AboutScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.build),
            title: Text("Settings"),
          ),
          Divider(),
        ],
      ),
    );
  }
}
