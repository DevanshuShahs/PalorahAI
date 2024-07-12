import 'package:app/Components/info_tooltip.dart';
import 'package:app/Components/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'question_4.dart';

class QuestionThree extends StatefulWidget {
  final Map<String, String> responses;  

  const QuestionThree({super.key, required this.responses});

  @override
  _QuestionThreeState createState() => _QuestionThreeState();
}

class _QuestionThreeState extends State<QuestionThree> {
  DateTime? selectedDate;
  final TextEditingController descriptionController = TextEditingController();

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _updateResponses() {
    Map<String, String> newResponses = {...widget.responses};
    if (selectedDate != null) {
      newResponses["Organization founded on"] = (DateFormat('MM/dd/yyyy').format(selectedDate!));
    }
    if (descriptionController.text.isNotEmpty) {
      newResponses["Organizational Description"] = descriptionController.text;
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => QuestionFour(responses: newResponses),
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
      appBar: AppBar(title: const Text('Non-profit Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const QuestionnaireProgress(currentStep: 3, totalSteps: 6),
            const SizedBox(height: 24),
            Text('When did you first establish your non-profit?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null ? 'Select Date' : DateFormat('MM/dd/yyyy').format(selectedDate!),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Text('Please provide a short description of your non-profit:', style: Theme.of(context).textTheme.titleLarge)),
                const InfoTooltip(message: 'This helps us understand your organization better.'),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Enter description here...',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
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
