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
      home: Scaffold(
        backgroundColor: const Color(0xFFD0DACC),
        appBar: AppBar(
          backgroundColor: const Color(0xFF7F9289),
          title: const Text('PalorahAI'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Positioned(
                left: 250,
                child: Text(
                  'Build an organization without limits',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 100, right: 100),
                child: Text(
                  "Build and scale with confidence. From a powerful" +
                      " financial advisor to advanced organization solutions—we’ve got you covered",
                  style: TextStyle(
                    color: const Color(0xFF25301E),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xFF7F9289),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: Size(300, 100),
                ),
                onPressed: () {},
                child: Text(
                  'Get Started',
                  style: TextStyle(
                      color: const Color(0xFF25301E),
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
