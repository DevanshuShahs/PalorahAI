import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:app/Pages/createdPlanHomePage.dart';
import 'package:app/Pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> with TickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late AnimationController _expandController;
  late AnimationController _drawController;
  late Animation<double> _expandAnimation;
  late Animation<double> _drawAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _drawController = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
    );

    _expandAnimation =
        Tween<double>(begin: 730.0, end: 770.0).animate(_expandController)
          ..addListener(() {
            setState(() {}); // Trigger rebuild with animation changes
          });

    _drawAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_drawController)
          ..addListener(() {
            setState(() {}); // Trigger rebuild with animation changes
          });

    _drawController.forward(); // Start the expanding animation

    // Delay the start of the drawing animation
    Future.delayed(const Duration(milliseconds: 10), () {
      _expandController.forward();
    });
  }

  @override
  void dispose() {
    _expandController.dispose();
    _drawController.dispose();
    super.dispose();
  }

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
      backgroundColor:
          Colors.transparent, // Set background color to transparent
      body: FutureBuilder<String?>(
        future: fetchUserPlan(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            Future.microtask(() {
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const createdPlanHomePage()),
              );
            });
            // Return an empty container while waiting for the navigation
            return Container();
          } else {
            return Stack(
        children: [
          // Background color
          Container(
            color: const Color(0xFFD0DACC),
          ),
          // Content
          Center(
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
                            color: Color(0xFF25301E)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const Flexible(
                    child: Text(
                      "Build and scale with confidence. From a powerful" +
                          " financial advisor to advanced organization solutions—we’ve got you covered",
                      style: TextStyle(
                        color: Color(0xFF25301E),
                        fontSize: 15,
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
                                  builder: (context) => loginPage()));
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
          // The logo
          Container(
            width: MediaQuery.of(context).size.width, // Fixed width for the logo
            height: MediaQuery.of(context).size.height * 0.5, // Fixed height for the logo
            child: Image.asset(
              'images/PCLogo.png', // Path to your background image
              fit: BoxFit.scaleDown,
            ),
          ),
          // Circle on top of everything
          Positioned(
            top: -300,
            left: -350,
            child: CustomPaint(
              size: Size(_expandAnimation.value, _expandAnimation.value),
              painter: CirclePainter(_drawAnimation.value),
            ),
          ),
        ],
      );
      }
      }
    ));
  }
}

class CirclePainter extends CustomPainter {
  final double progress;

  CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFbc9c22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = -90.0;
    final sweepAngle = 360.0 * progress;

    canvas.drawArc(
      rect,
      startAngle * 3.1415927 / 180,
      sweepAngle * 3.1415927 / 180,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}