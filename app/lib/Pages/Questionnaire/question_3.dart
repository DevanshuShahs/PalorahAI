import 'package:app/Pages/Questionnaire/question_2.dart';
import 'package:app/Pages/Questionnaire/question_4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuestionThree extends StatefulWidget {
  QuestionThree({super.key, required this.responses});

  List<String> responses;

  @override
  State<QuestionThree> createState() {
    return _QuestionThreeState();
  }
}

class _QuestionThreeState extends State<QuestionThree> {
  DateTime? selectedDate;
  TextEditingController descriptionController = TextEditingController();
  bool hasInputtedData = false;
  late List<String> tempResponses;

  @override
  void initState() {
    super.initState();
    tempResponses = List.from(widget.responses); // Create a copy of the responses
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

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
        _checkInputtedData();
      });
    }
  }

  void _checkInputtedData() {
    setState(() {
      hasInputtedData =
          selectedDate != null || descriptionController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
                    Navigator.pop(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => QuestionTwo(responses: widget.responses)));
          },
        ),
        actions: [
          hasInputtedData
              ? IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (selectedDate != null) {
                    tempResponses.add(DateFormat('MM/dd/yyyy').format(selectedDate!));
                    }
                    if (descriptionController.text.isNotEmpty) {
                    tempResponses.add(descriptionController.text);
                    }
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                QuestionFour(responses: tempResponses)));
                  },
                )
              : TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                QuestionFour(responses: widget.responses)));
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.green, fontSize: 17),
                  ),
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'When did you first establish your non-profit?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  selectedDate == null
                      ? 'Select Date'
                      : DateFormat('MM/dd/yyyy').format(selectedDate!),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Please provide a short description of your non-profit:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter description here...',
              ),
              onChanged: (text) {
                _checkInputtedData();
              },
            ),
          ],
        ),
      ),
    );
  }
}
