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
                        return buildLoadingScreen();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello again!',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Text(
                              snapshot.data ?? 'Guest',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const Text(
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add functionality for viewing plan
                },
                child: const Text('View plan', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Add functionality for creating new plan
                },
                child: const Text('Create new plan', style: TextStyle(fontSize: 18)),
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

  Widget buildLoadingScreen() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(1, (index) => buildShimmerPlaceholder()),
      ),
    );
  }

  Widget buildShimmerPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
