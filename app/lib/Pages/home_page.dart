import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:app/Pages/createdPlanHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> fetchUserPlan() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await firestore
            .collection('plans')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first['plan'];
        }
        print(querySnapshot.docs.first['plan']);
      }
    } catch (e) {
      print('Error fetching plan: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set background color to transparent
      body: FutureBuilder<String?>(
        future: fetchUserPlan(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
          Future.microtask(() {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => createdPlanHomePage()),
            );
          });
          // Return an empty container while waiting for the navigation
          return Container();
          } else {
            return Stack(
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
                      width: MediaQuery.of(context).size.width * 0.9,
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.white),
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
                                      CupertinoPageRoute(
                                          builder: (context) => QuestionOne()));
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
            );
          }
        },
      ),
    );
  }
}