import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFD0DACC),
          title: const Text('PalorahAI'),
        ),
        body: Center(
            child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.greenAccent,
              foregroundColor: Colors.black,
              backgroundColor: const Color(0xFFD0DACC),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
              minimumSize: Size(300, 100), //////// HERE
            ),
            onPressed: () {},
            child: Text('Get Started'),
          )

          ),
        ),
    );
  }
}
