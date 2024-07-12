import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlanStep {
  final String title;
  final List<String> substeps;
  bool isCompleted;

  PlanStep({required this.title, required this.substeps, this.isCompleted = false});
}

class UserPlan extends StatefulWidget {
  const UserPlan({Key? key}) : super(key: key);

  @override
  State<UserPlan> createState() => _UserPlanState();
}

class _UserPlanState extends State<UserPlan> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<PlanStep>? planSteps;

  @override
  void initState() {
    super.initState();
    fetchUserPlan();
  }

  Future<void> fetchUserPlan() async {
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
        var docData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        print('Raw Firestore data: $docData'); // Log raw data

        if (docData.containsKey('plan')) {
          var planData = docData['plan'];
          print('Plan data type: ${planData.runtimeType}'); // Log plan data type

          if (planData is List) {
            setState(() {
              planSteps = (planData as List).map((step) {
                if (step is Map<String, dynamic>) {
                  return PlanStep(
                    title: step['title']?.toString() ?? 'No Title',
                    substeps: (step['substeps'] as List?)?.cast<String>() ?? [],
                    isCompleted: step['isCompleted'] as bool? ?? false,
                  );
                } else {
                  print('Unexpected step format: $step');
                  return PlanStep(title: 'Invalid Step', substeps: []);
                }
              }).toList();
            });
          } else if (planData is String) {
            // Handle case where plan is a single string
            setState(() {
              planSteps = [PlanStep(title: planData, substeps: [])];
            });
          } else {
            print('Unexpected plan data format');
            setState(() {
              planSteps = [PlanStep(title: 'Invalid Plan Format', substeps: [])];
            });
          }
        } else {
          print('No plan field found in document');
          setState(() {
            planSteps = [];
          });
        }
      } else {
        print('No documents found');
        setState(() {
          planSteps = [];
        });
      }
    }
  } catch (e) {
    print('Error fetching plan: $e');
    setState(() {
      planSteps = [PlanStep(title: 'Error: $e', substeps: [])];
    });
  }
}

  Widget buildLoadingScreen() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(6, (index) => buildShimmerPlaceholder()),
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
            width: 24,
            height: 24,
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
                  height: 16.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStepWithCheckbox(PlanStep step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: step.isCompleted,
              onChanged: (bool? value) {
                setState(() {
                  step.isCompleted = value ?? false;
                });
                // Optionally update Firestore here
              },
            ),
            Expanded(
              child: Text(
                step.title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        ...step.substeps.map((substep) => Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            substep,
            style: const TextStyle(fontSize: 12),
          ),
        )).toList(),
        SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Plan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (planSteps == null)
                  buildLoadingScreen()
                else if (planSteps!.isEmpty)
                  Center(
                    child: Text(
                      'No plan found for this user.',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ...planSteps!.map((step) => buildStepWithCheckbox(step)).toList(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}