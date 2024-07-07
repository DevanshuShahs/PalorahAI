import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

class PlanStep {
  final String title;
  final List<String> substeps;
  bool isCompleted;

  PlanStep({required this.title, required this.substeps, this.isCompleted = false});
}

class Plan extends StatefulWidget {
  Plan({super.key, required this.responses});

  final List<String> responses;

  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  List<PlanStep>? planSteps;
  final gemini = Gemini.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchStory();
  }

  void fetchStory() async {
  try {
    final value = await gemini.text(
        "give a 5 step plan that takes into account these parameters for a person trying to start a nonprofit " +
            widget.responses.join(', '));
    if (value != null && value.output != null) {
      setState(() {
        planSteps = parsePlanSteps(value.output!);
      });
      savePlanToFirestore(planSteps!);
    } else {
      setState(() {
        planSteps = [PlanStep(title: 'No output', substeps: [])];
      });
    }
  } catch (e) {
    setState(() {
      planSteps = [PlanStep(title: 'Error: $e', substeps: [])];
    });
  }
}


  List<PlanStep> parsePlanSteps(String output) {
    List<PlanStep> steps = [];
    List<String> lines = output.split('\n');
    PlanStep? currentStep;

    for (String line in lines) {
      if (line.trim().startsWith("**Step")) {
        if (currentStep != null) {
          steps.add(currentStep);
        }
        currentStep = PlanStep(title: line.trim(), substeps: []);
      } else if (currentStep != null && line.trim().isNotEmpty) {
        currentStep.substeps.add(line.trim());
      }
    }
    
    if (currentStep != null) {
      steps.add(currentStep);
    }

    return steps;
  }

  void savePlanToFirestore(List<PlanStep> steps) async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await firestore.collection('plans').add({
          'userId': user.uid,
          'plan': steps.map((step) => {
            'title': step.title,
            'substeps': step.substeps,
            'isCompleted': step.isCompleted
          }).toList(),
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error saving to Firestore: $e');
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
}