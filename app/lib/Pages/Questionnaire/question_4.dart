import 'package:flutter/material.dart';
import '../shared_widgets.dart';
import 'question_5.dart';

class QuestionFour extends StatefulWidget {
  final List<String> responses;

  const QuestionFour({Key? key, required this.responses}) : super(key: key);

  @override
  _QuestionFourState createState() => _QuestionFourState();
}

class _QuestionFourState extends State<QuestionFour> {
  String? financialStatus;
  String? fundraisingExperience;

  final List<String> financialStatusOptions = [
    'Very stable',
    'Stable',
    'Unstable',
    'Very unstable'
  ];

  final List<String> fundraisingExperienceOptions = [
    'None',
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  void _updateResponses() {
    List<String> newResponses = [...widget.responses];
    if (financialStatus != null) newResponses.add(financialStatus!);
    if (fundraisingExperience != null) newResponses.add(fundraisingExperience!);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => QuestionFive(responses: newResponses),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Financial Status')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionnaireProgress(currentStep: 4, totalSteps: 6),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Text('What is the current financial status of your organization?', style: Theme.of(context).textTheme.titleLarge)),
                InfoTooltip(message: 'This helps us understand your financial needs.'),
              ],
            ),
            SizedBox(height: 16),
            CustomDropdown<String>(
              value: financialStatus,
              items: financialStatusOptions,
              hint: 'Select financial status',
              onChanged: (newValue) {
                setState(() {
                  financialStatus = newValue;
                });
              },
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Text('How much experience do you have in fundraising and grant acquisition?', style: Theme.of(context).textTheme.titleLarge)),
                InfoTooltip(message: 'This helps us tailor our recommendations to your experience level.'),
              ],
            ),
            SizedBox(height: 16),
            CustomDropdown<String>(
              value: fundraisingExperience,
              items: fundraisingExperienceOptions,
              hint: 'Select experience level',
              onChanged: (newValue) {
                setState(() {
                  fundraisingExperience = newValue;
                });
              },
            ),
            SizedBox(height: 24),
            Text('Other responses:', style: Theme.of(context).textTheme.titleMedium),
            Text(widget.responses.join(', ')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateResponses,
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}