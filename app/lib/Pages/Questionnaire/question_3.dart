import 'package:app/Components/info_tooltip.dart';
import 'package:app/Components/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'question_4.dart';

class QuestionThree extends StatefulWidget {
  final List<String> responses;

  const QuestionThree({Key? key, required this.responses}) : super(key: key);

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
    List<String> newResponses = [...widget.responses];
    if (selectedDate != null) {
      newResponses.add(DateFormat('MM/dd/yyyy').format(selectedDate!));
    }
    if (descriptionController.text.isNotEmpty) {
      newResponses.add(descriptionController.text);
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
    return Scaffold(
      appBar: AppBar(title: Text('Non-profit Details')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionnaireProgress(currentStep: 3, totalSteps: 6),
            SizedBox(height: 24),
            Text('When did you first establish your non-profit?', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null ? 'Select Date' : DateFormat('MM/dd/yyyy').format(selectedDate!),
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Text('Please provide a short description of your non-profit:', style: Theme.of(context).textTheme.titleLarge)),
                InfoTooltip(message: 'This helps us understand your organization better.'),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter description here...',
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
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
