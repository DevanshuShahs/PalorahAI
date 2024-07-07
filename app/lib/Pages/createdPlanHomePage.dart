import 'package:app/Pages/userPlan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../Services/authentication.dart';

class CreatedPlanHomePage extends StatefulWidget {
  const CreatedPlanHomePage({super.key});

  @override
  State<CreatedPlanHomePage> createState() => _CreatedPlanHomePageState();
}

class _CreatedPlanHomePageState extends State<CreatedPlanHomePage>
    with TickerProviderStateMixin {
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

    _expandAnimation = Tween<double>(begin: 730.0, end: 770.0).animate(_expandController)
      ..addListener(() {
        setState(() {}); // Trigger rebuild with animation changes
      });

    _drawAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_drawController)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('images/PCLogo.png'),
                  ),
                  SizedBox(width: 15),
                  FutureBuilder<String>(
                    future: fetchUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello again!',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Text(
                              snapshot.data ?? 'Guest',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'FINANCIAL BEGINNER',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add functionality for viewing plan
                },
                child: Text('View plan', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Add functionality for creating new plan
                },
                child: Text('Create new plan', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
