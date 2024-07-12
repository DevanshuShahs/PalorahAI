import 'package:app/Components/info_tooltip.dart';
import 'package:app/Components/progress_bar.dart';
import 'package:flutter/material.dart';
import 'question_3.dart';

class QuestionTwo extends StatefulWidget {
  final Map<String, String> responses;

  const QuestionTwo({super.key, required this.responses});

  @override
  _QuestionTwoState createState() => _QuestionTwoState();
}

class _QuestionTwoState extends State<QuestionTwo> {
  final List<String> goals = [
    "Organizational Development",
    "Community Engagement",
    "Increased Funding"
  ];
  List<bool> isChecked = [false, false, false];

  void _updateResponses() {
    Map<String, String> selectedGoals = {};
    for (int i = 0; i < goals.length; i++) {
      if (isChecked[i]) {
      selectedGoals["Organizational Goal$i"] = goals[i];
      }
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => QuestionThree(
          responses: {...widget.responses, ...selectedGoals},
        ),
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
      appBar: AppBar(title: const Text('Your Goals')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const QuestionnaireProgress(currentStep: 2, totalSteps: 6),
            const SizedBox(height: 24),
            Text('What are your goals?',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...List.generate(goals.length, (index) {
              return CheckboxListTile(
                title: Text(goals[index]),
                value: isChecked[index],
                onChanged: (bool? value) {
                  setState(() {
                    isChecked[index] = value ?? false;
                  });
                },
                secondary: const InfoTooltip(
                    message:
                        'Selecting this goal will help us tailor our recommendations.'),
              );
            }),
            const SizedBox(height: 24),
            Text('Other responses:',
                style: Theme.of(context).textTheme.titleMedium),
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
