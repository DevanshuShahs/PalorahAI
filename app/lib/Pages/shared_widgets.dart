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

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hint;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        hintText: hint,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }
}

class InfoTooltip extends StatelessWidget {
  final String message;

  const InfoTooltip({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: Icon(Icons.info_outline, size: 16),
    );
  }
}
