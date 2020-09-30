import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
          child: Text(
            "About",
            textAlign: TextAlign.center,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushNamed(DashboardScreen.routeName);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Mappa Vita",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "1.1.0",
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Privacy"),
            SizedBox(
              height: 10,
            ),
            Text("Agreement"),
          ],
        ),
      ),
    );
  }
}
