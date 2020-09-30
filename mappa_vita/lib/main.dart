import 'package:flutter/material.dart';
import 'package:mappa_vita/provider/sheets.dart';
import 'package:mappa_vita/screens/about_screen.dart';
import 'package:mappa_vita/screens/authentication.dart';
import 'package:mappa_vita/screens/dashboard_screen.dart';
import 'package:mappa_vita/screens/sheet_screen.dart';
import 'package:mappa_vita/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Sheets(),
          ),
        ],
        child: MaterialApp(
          title: 'MappaVite',
          theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.blue,
          ),
          home: SplashScreen(),
          routes: {
            AboutScreen.routeName: (ctx) => AboutScreen(),
            DashboardScreen.routeName: (ctx) => DashboardScreen(
                  credentials: '',
                ),
            // SheetScreen.routeName: (ctx) => SheetScreen(
            //       id: '',
            //     )
          },
        ));
  }
}
