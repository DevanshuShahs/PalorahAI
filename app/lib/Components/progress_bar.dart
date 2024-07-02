import 'package:flutter/material.dart';

class QuestionnaireProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const QuestionnaireProgress({Key? key, required this.currentStep, required this.totalSteps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: currentStep / totalSteps,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
        SizedBox(height: 8),
        Text(
          'Question $currentStep of $totalSteps',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}