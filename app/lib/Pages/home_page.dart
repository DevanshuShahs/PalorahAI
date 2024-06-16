import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/Pages/login_page.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.transparent, // Set background color to transparent
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
                    Colors.green.withOpacity(0.1), // White with 50% opacity
                    Colors.black.withOpacity(1), // Black with 50% opacity
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: MediaQuery.of(context).size.width*0.9,
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
                                fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const Flexible(
                        // padding: EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
                        child: Text(
                          "Build and scale with confidence. From a powerful" +
                              " financial advisor to advanced organization solutions—we’ve got you covered",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
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
                              minimumSize: const Size(250, 60),
                            ),
                            onPressed: () {
                              Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => loginPage()));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                'Get Started',
                                style: TextStyle(
                                    color: Color(0xFF25301E),
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600),
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
          ],
        ),
      );
  }
}