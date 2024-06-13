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
        backgroundColor: Colors.transparent, // Set background color to transparent
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'images/plant.jpg', // Path to your background image
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.85],
                  colors: [
                    Colors.green.withOpacity(0), // White with 50% opacity
                    Colors.black.withOpacity(1), // Black with 50% opacity
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Build an organization without limits',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Build and scale with confidence. From a powerful" +
                            " financial advisor to advanced organization solutions—we’ve got you covered",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.greenAccent,
                            foregroundColor: Colors.black,
                            backgroundColor: const Color(0xFF7F9289),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            minimumSize: Size(250, 60),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
