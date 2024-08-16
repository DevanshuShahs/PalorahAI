import 'package:app/Components/custom_button.dart';
import 'package:app/Pages/Navbar/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class PlanStep {
  final String title;
  final List<String> substeps;
  bool isCompleted;
  DateTime? completionDate;

  PlanStep({
    required this.title,
    required this.substeps,
    this.isCompleted = false,
    DateTime? completionDate,
  });
}

class Plan extends StatefulWidget {
  const Plan({super.key, required this.responses});

  final Map<String, String> responses;

  final String prompt =
      """Provide a detailed 5-step plan to help a non-profit organization achieve its financial and organizational goals. The organization has shared key details about its mission, goals, current status, and future objectives through a series of responses to specific questions. The desired outcome is a specific, actionable list of steps that will guide the organization in enhancing its fundraising efforts, improving organizational efficiency, and increasing community outreach. The plan must be realistic and achievable within a year, considering current financial constraints and emphasizing sustainable growth. The steps should include innovative ideas for online fundraising, community engagement, and grant application strategies. The tone should be formal and professional, suitable for presentation to the organization’s board and potential donors. Provide a valid timeline to be followed for each step and give the organization a benchmark to measure their progress in each step and sub step. Tell them how they would be able to know that the step is complete and can be checked off.
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

class _PlanState extends State<Plan> with SingleTickerProviderStateMixin {
  List<PlanStep>? planSteps;
  final gemini = Gemini.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String prompt;
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showButton = true;
  TextEditingController _planNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStory();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener); // Add this line

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _planNameController.dispose();

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      bool isBottom = _scrollController.position.pixels != 0;
      if (isBottom && planSteps != null) {
        setState(() {
          _showButton = false;
        });
      } else {
        setState(() {
          _showButton = true;
        });
      }
    } else {
      setState(() {
        _showButton = true;
      });
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
        // savePlanToFirestore(planSteps!);
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
          'planName': _planNameController.text,
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
            height: 85,
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
        title: const Text('Create Your Plan'),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (planSteps == null)
                      buildLoadingScreen()
                    else
                      ...planSteps!.map((step) => buildSteps(step)),
                    const SizedBox(height: 25),
                    if (planSteps != null)
                      CustomButton(
                        disabled: planSteps == null,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Name Your Plan'),
                                content: TextField(
                                  controller: _planNameController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter a name for your plan',
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Save'),
                                    onPressed: () {
                                      if (_planNameController.text.isNotEmpty) {
                                        savePlanToFirestore(planSteps!);
                                        Navigator.of(context).pop(); // Dismiss the dialog
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Plan "${_planNameController.text}" saved successfully!')),
                                        );
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) =>
                                                Homepage(),
                                            transitionsBuilder: (context, animation,
                                                secondaryAnimation, child) {
                                              return FadeTransition(
                                                  opacity: animation, child: child);
                                            },
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Please enter a plan name')),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Save Plan'),
                      ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          if (_showButton && planSteps != null)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _scrollToBottom,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 5 * _animation.value),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildSteps(PlanStep step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
        const SizedBox(height: 8),
      ],
    );
  }
}
