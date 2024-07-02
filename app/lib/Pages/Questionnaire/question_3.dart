import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'question_2.dart';
import 'question_4.dart';

class QuestionThree extends StatefulWidget {
  const QuestionThree({super.key, required this.responses});

  final List<String> responses;

  @override
  State<QuestionThree> createState() => _QuestionThreeState();
}

class _QuestionThreeState extends State<QuestionThree> {
  DateTime? selectedDate;
  final TextEditingController descriptionController = TextEditingController();
  late List<String> tempResponses;

  @override
  void initState() {
    super.initState();
    tempResponses = List.from(widget.responses);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _updateResponses() {
    tempResponses = List.from(widget.responses);
    if (selectedDate != null) {
      tempResponses.add(DateFormat('MM/dd/yyyy').format(selectedDate!));
    }
    if (descriptionController.text.isNotEmpty) {
      tempResponses.add(descriptionController.text);
    }
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
      });
    }
  }

  bool get _hasInputtedData => selectedDate != null || descriptionController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Non-profit Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_hasInputtedData) _updateResponses();
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => QuestionFour(responses: _hasInputtedData ? tempResponses : widget.responses)),
              );
            },
            child: Text(_hasInputtedData ? "Next" : "Skip"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'When did you first establish your non-profit?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              const Text(
                'Please provide a short description of your non-profit:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter description here...',
                ),
                onChanged: (text) => setState(() {}),
              ),
              const SizedBox(height: 24),
              const Text(
                'Other responses:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.responses.join(', ')),
            ],
          ),
        ),
      ),
    );
  }
}