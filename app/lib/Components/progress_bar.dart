import 'package:flutter/material.dart';

class QuestionnaireProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const QuestionnaireProgress({super.key, required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: currentStep / totalSteps,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 8),
        Text(
          'Question $currentStep of $totalSteps',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}