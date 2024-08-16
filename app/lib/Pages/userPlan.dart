import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class PlanStep {
  final String title;
  final List<String> substeps;
  bool isCompleted;
  DateTime? completionDate;

  PlanStep(
      {required this.title,
      required this.substeps,
      this.isCompleted = false,
      this.completionDate});
}

class UserPlan extends StatefulWidget {
  final String planId;

  const UserPlan({super.key, required this.planId});

  @override
  State<UserPlan> createState() => _UserPlanState();
}

class _UserPlanState extends State<UserPlan> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<PlanStep>? planSteps;
  String planName = '';

  @override
  void initState() {
    super.initState();
    fetchUserPlan();
  }

    Future<void> fetchUserPlan() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        DocumentSnapshot documentSnapshot = await firestore
            .collection('plans')
            .doc(widget.planId)
            .get();

        if (documentSnapshot.exists) {
          var docData = documentSnapshot.data() as Map<String, dynamic>;
          print('Raw Firestore data: $docData');

          setState(() {
            planName = docData['planName'] ?? 'Unnamed Plan';
          });

          if (docData.containsKey('plan')) {
            var planData = docData['plan'];
            print('Plan data type: ${planData.runtimeType}');

            if (planData is List) {
              setState(() {
                planSteps = (planData).map((step) {
                  if (step is Map<String, dynamic>) {
                    return PlanStep(
                      title: step['title']?.toString() ?? 'No Title',
                      substeps:
                          (step['substeps'] as List?)?.cast<String>() ?? [],
                      isCompleted: step['isCompleted'] as bool? ?? false,
                    );
                  } else {
                    print('Unexpected step format: $step');
                    return PlanStep(title: 'Invalid Step', substeps: []);
                  }
                }).toList();
              });
            } else if (planData is String) {
              setState(() {
                planSteps = [PlanStep(title: planData, substeps: [])];
              });
            } else {
              print('Unexpected plan data format');
              setState(() {
                planSteps = [
                  PlanStep(title: 'Invalid Plan Format', substeps: [])
                ];
              });
            }
          } else {
            print('No plan field found in document');
            setState(() {
              planSteps = [];
            });
          }
        } else {
          print('No document found with ID: ${widget.planId}');
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
                  step.completionDate =
                      step.isCompleted ? DateTime.now() : null;
                });
                // Optionally update Firestore here
              },
            ),
            Expanded(
              child: Text(
                step.title.replaceAll('*', ''),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: step.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: step.isCompleted ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ],
        ),
        ...step.substeps.map((substep) {
          String displayText = substep.trim();
          bool isBold =
              displayText.startsWith('* **') && displayText.endsWith('**');

          // Remove all asterisks from the text
          displayText = displayText.replaceAll('*', '').trim();

          return Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      decoration: step.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: step.isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        if (step.isCompleted && step.completionDate != null)
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Completed on: ${DateFormat('MMM dd yyyy').format(step.completionDate!)}',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planName),
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
                  const Center(
                    child: Text(
                      'No plan found for this user.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ...planSteps!.map((step) => buildStepWithCheckbox(step)),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }}