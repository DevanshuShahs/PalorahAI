import 'package:flutter/material.dart';
import '../shared_widgets.dart';
import 'question_3.dart';

class QuestionTwo extends StatefulWidget {
  final List<String> responses;

  const QuestionTwo({Key? key, required this.responses}) : super(key: key);

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
    List<String> selectedGoals = [];
    for (int i = 0; i < goals.length; i++) {
      if (isChecked[i]) selectedGoals.add(goals[i]);
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => QuestionThree(
          responses: [...widget.responses, ...selectedGoals],
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Goals')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionnaireProgress(currentStep: 2, totalSteps: 6),
            SizedBox(height: 24),
            Text('What are your goals?', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            ...List.generate(goals.length, (index) {
              return CheckboxListTile(
                title: Text(goals[index]),
                value: isChecked[index],
                onChanged: (bool? value) {
                  setState(() {
                    isChecked[index] = value ?? false;
                  });
                },
                secondary: InfoTooltip(message: 'Selecting this goal will help us tailor our recommendations.'),
              );
            }),
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