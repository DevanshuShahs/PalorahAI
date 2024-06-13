import 'package:app/Pages/home_page.dart';
import 'package:app/Pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Fonts',
      // Set Raleway as the default app font.
      theme: ThemeData(fontFamily: 'PlayfairDisplay'),
      initialRoute: "/login",
      routes: {
        "/login": (context) => loginPage(),
        "/home": (context) =>homePage(),
      },
    );
  }
}