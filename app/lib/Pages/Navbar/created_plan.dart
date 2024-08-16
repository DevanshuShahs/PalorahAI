import 'package:app/Pages/landing_page.dart';
import 'package:app/Pages/userPlan.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../Services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatedPlanHomePage extends StatefulWidget {
  const CreatedPlanHomePage({super.key});

  @override
  State<CreatedPlanHomePage> createState() => _CreatedPlanHomePageState();
}

class _CreatedPlanHomePageState extends State<CreatedPlanHomePage>
    with AutomaticKeepAliveClientMixin {
  late Future<String> _userNameFuture;
  late Stream<QuerySnapshot> _plansStream;

  @override
  void initState() {
    super.initState();
    _userNameFuture = fetchUserName();
    _plansStream = _getPlansStream();
  }

  @override
  bool get wantKeepAlive => true;

  Stream<QuerySnapshot> _getPlansStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('plans')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    }
    return Stream.empty();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildUserHeader(),
              const SizedBox(height: 20),
              const Text(
                "Your plans",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay',
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildPlanGrid(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildCreateNewPlanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildUserHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('images/PCLogo.png'),
        ),
        const SizedBox(width: 15),
        FutureBuilder<String>(
          future: _userNameFuture,
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
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    snapshot.data ?? 'Guest',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'FINANCIAL BEGINNER',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildPlanGrid() {
  return StreamBuilder<QuerySnapshot>(
    stream: _plansStream,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return buildShimmerEffect();
      }

      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No plans created yet.'));
      }

      final plans = snapshot.data!.docs;

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index].data() as Map<String, dynamic>;
          return _buildPlanButton(plan, plans[index].id);
        },
      );
    },
  );
}


  Widget _buildPlanButton(Map<String, dynamic> plan, String planId) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => UserPlan(planId: planId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description, size: 40),
          const SizedBox(height: 10),
          Text(
            plan['planName'] ?? 'Unnamed Plan',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCreateNewPlanButton() {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LandingPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 24),
            SizedBox(width: 8),
            Text(
              'Create new plan',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
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
}
