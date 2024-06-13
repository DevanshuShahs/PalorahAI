import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Fonts',
      // Set Raleway as the default app font.
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
        backgroundColor:
            Colors.transparent, // Set background color to transparent
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'images/earth.jpg', // Path to your background image
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.75],
                  colors: [
                    const Color.fromARGB(255, 132, 249, 136)
                        .withOpacity(0.1), // White with 50% opacity
                    const Color.fromARGB(255, 0, 0, 0)
                        .withOpacity(1), // Black with 50% opacity
                  ],
                ),
              ),
              child: Center(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Build and scale without limits',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const Flexible(
                          child: Text(
                            "From a powerful" +
                                " financial advisor to advanced organization solutions—we’ve got you covered",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                            
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30, top: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.greenAccent,
                                foregroundColor: Colors.black,
                                backgroundColor: const Color(0xFF7F9289),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: const Size(250, 80),
                              ),
                              onPressed: () {},
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Text(
                                  'Get Started',
                                  style: TextStyle(
                                      color: Color(0xFF25301E),
                                      fontSize: 35,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
