import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Scaffold(
          appBar: AppBar(
          backgroundColor: const Color(0xFFD0DACC),
          title: const Text('PalorahAI'),
        ),
        body: Center(
          child: const Padding(
            child: const Text('Get Started'),
            padding: EdgeInsets.all(10),
          ),
        )
        ),
      )
    );
  }
}

