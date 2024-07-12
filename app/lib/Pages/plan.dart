import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

class PlanStep {
  final String title;
  final List<String> substeps;
  bool isCompleted;

  PlanStep(
      {required this.title, required this.substeps, this.isCompleted = false});
}

class Plan extends StatefulWidget {
  const Plan({super.key, required this.responses});

  final Map<String, String> responses;

  final String prompt = """Provide a detailed 5-step plan to help a non-profit organization achieve its financial and organizational goals. The organization has shared key details about its mission, goals, current status, and future objectives through a series of responses to specific questions. The desired outcome is a specific, actionable list of steps that will guide the organization in enhancing its fundraising efforts, improving organizational efficiency, and increasing community outreach. The plan must be realistic and achievable within a year, considering current financial constraints and emphasizing sustainable growth. The steps should include innovative ideas for online fundraising, community engagement, and grant application strategies. The tone should be formal and professional, suitable for presentation to the organization’s board and potential donors. Provide a valid timeline to be followed for each step and give the organization a benchmark to measure their progress in each step and sub step. Tell them how they would be able to know that the step is complete and can be checked off.
Use this schema to format your response: 
Step 1: {Step 1 name}
Description: {max 25 word description of Step 1}
Timeline: {Duration of Step 1}
Benchmark: {Measure of completion. How user knows when step 1 is complete}
Substeps: {
{Substep 1}
{Substep 2}
{Substep 3}}
Expected Result: {What outcome the user should expect from this step}
Step 2: {Step 2 name}
Description: {max 25 word description of Step 2}
Timeline: {Duration of Step 2}
Benchmark: {Measure of completion. How user knows when step 1 is complete}
Substeps: {
{Substep 1}
{Substep 2}
{Substep 3}}
Expected Result: {What outcome the user should expect from this step}
Step 3: {Step 3 name}
Description: {max 25 word description of Step 3}
Timeline: {Duration of Step 3}
Benchmark: {Measure of completion. How user knows when step 1 is complete}
Substeps: {
{Substep 1}
{Substep 2}
{Substep 3}}
Expected Result: {What outcome the user should expect from this step}
Step 4: {Step 4 name}
Description: {max 25 word description of Step 4}
Timeline: {Duration of Step 4}
Benchmark: {Measure of completion. How user knows when step 1 is complete}
Substeps: {
{Substep 1}
{Substep 2}
{Substep 3}}
Expected Result: {What outcome the user should expect from this step}
Step 5: {Step 5 name}
Description: {max 25 word description of Step 5}
Timeline: {Duration of Step 5}
Benchmark: {Measure of completion. How user knows when step 1 is complete}
Substeps: {
{Substep 1}
{Substep 2}
{Substep 3}}
Expected Result: {What outcome the user should expect from this step}""";

  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  List<PlanStep>? planSteps;
  final gemini = Gemini.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String prompt;

  @override
  void initState() {
    super.initState();
    fetchStory();
  }

  void fetchStory() async {
   try {
    // Combine prompt and responses
    String combinedInput = "${widget.prompt}\n\n Here are the Responses:\n";
    widget.responses.forEach((key, value) {
      combinedInput += "$key: $value\n";
    });
    final value = await gemini.text(combinedInput);
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
          'plan': steps
              .map((step) => {
                    'title': step.title,
                    'substeps': step.substeps,
                    'isCompleted': step.isCompleted
                  })
              .toList(),
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
                  ...planSteps!
                      .map((step) => buildStepWithCheckbox(step))
                      ,
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
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        ...step.substeps
            .map((substep) => Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Text(
                    substep,
                    style: const TextStyle(fontSize: 12),
                  ),
                ))
            ,
        const SizedBox(height: 8),
      ],
    );
  }
}
