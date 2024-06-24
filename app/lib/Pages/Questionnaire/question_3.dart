import 'package:app/Pages/Questionnaire/question_2.dart';
import 'package:app/Pages/Questionnaire/question_4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:intl/intl.dart';
=======
import 'package:flutter_gemini/flutter_gemini.dart';
>>>>>>> f2b1fb60c2c24229b60d5285a9ee414adc53eaad

class QuestionThree extends StatefulWidget {
  QuestionThree({super.key, required this.responses});

  List<String> responses;

  @override
  State<QuestionThree> createState() {
    return _QuestionThreeState();
  }
}


class _QuestionThreeState extends State<QuestionThree> {
<<<<<<< HEAD
  DateTime? selectedDate;
  TextEditingController descriptionController = TextEditingController();
  bool hasInputtedData = false;
  late List<String> tempResponses;
=======
  final gemini = Gemini.instance;
  bool isChecked = false;
  String story = "Loading...";
>>>>>>> f2b1fb60c2c24229b60d5285a9ee414adc53eaad

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
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
=======
    fetchStory();
  }

  void fetchStory() async {
    try {
      final value = await gemini.text("give a 5 step plan that takes into account these parameters for a person trying to start a nonprofit "+ widget.responses.join(', '));
      setState(() {
        story = value?.output ?? 'No output';
      });
    } catch (e) {
      setState(() {
        story = 'Error: $e';
>>>>>>> f2b1fb60c2c24229b60d5285a9ee414adc53eaad
      });
    }
  }

<<<<<<< HEAD
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
=======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(story),
>>>>>>> f2b1fb60c2c24229b60d5285a9ee414adc53eaad
      ),
    );
  }
}


// return Scaffold(
//       body: Center(
//         child: Text(widget.responses.join(', ')),
//       ),
//     );