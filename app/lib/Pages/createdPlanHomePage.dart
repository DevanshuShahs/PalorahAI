import 'package:app/Pages/home_page.dart';
import 'package:app/Pages/userPlan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import '../Services/authentication.dart';

class CreatedPlanHomePage extends StatefulWidget {
  const CreatedPlanHomePage({super.key});

  @override
  State<CreatedPlanHomePage> createState() => _CreatedPlanHomePageState();
}

class _CreatedPlanHomePageState extends State<CreatedPlanHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('images/PCLogo.png'),
                  ),
                  const SizedBox(width: 15),
                  FutureBuilder<String>(
                    future: fetchUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return buildShimmerEffect();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello again!',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Text(
                              snapshot.data ?? 'Guest',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'FINANCIAL BEGINNER',
                              style:
                                  TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const UserPlan(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                child: const Text('View plan', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          HomePage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                child: const Text('Create new plan',
                    style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 20,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            width: 150,
            height: 20,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }