import 'package:app/Components/custom_dropdown.dart';
import 'package:app/Components/info_tooltip.dart';
import 'package:app/Components/progress_bar.dart';
import 'package:flutter/material.dart';
import 'question_6.dart';

class QuestionFive extends StatefulWidget {
  final Map<String, String> responses;  

  const QuestionFive({super.key, required this.responses});

  @override
  _QuestionFiveState createState() => _QuestionFiveState();
}

class _QuestionFiveState extends State<QuestionFive> {
  String? membershipCount;
  String? organizationStructure;

  final List<String> membershipCountOptions = [
    '1-10',
    '11-50',
    '51-100',
    '101-500',
    '500+'
  ];

  final List<String> organizationStructureOptions = [
    'Board of Directors',
    'Executive Leadership',
    'Hierarchical',
    'Flat',
    'Matrix'
  ];

  void _updateResponses() {
    Map<String, String> newResponses = {...widget.responses};
    if (membershipCount != null) newResponses["Membership Count"] = (membershipCount!);
    if (organizationStructure != null) newResponses["Organzational Structure"] = (organizationStructure!);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => QuestionSix(responses: newResponses),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
        List<String> values = widget.responses.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const QuestionnaireProgress(currentStep: 5, totalSteps: 6),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Text('What is the current membership count of your organization?', style: Theme.of(context).textTheme.titleLarge)),
                const InfoTooltip(message: 'This helps us understand the scale of your organization.'),
              ],
            ),
            const SizedBox(height: 16),
            CustomDropdown<String>(
              value: membershipCount,
              items: membershipCountOptions,
              hint: 'Select membership count',
              onChanged: (newValue) {
                setState(() {
                  membershipCount = newValue;
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Text('What is the organization structure of your non-profit?', style: Theme.of(context).textTheme.titleLarge)),
                const InfoTooltip(message: 'This helps us understand your organizational setup.'),
              ],
            ),
            const SizedBox(height: 16),
            CustomDropdown<String>(
              value: organizationStructure,
              items: organizationStructureOptions,
              hint: 'Select organization structure',
              onChanged: (newValue) {
                setState(() {
                  organizationStructure = newValue;
                });
              },
            ),
            const SizedBox(height: 24),
            Text('Other responses:', style: Theme.of(context).textTheme.titleMedium),
            Text(values.join(', ')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateResponses,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}