import 'package:app/Pages/Questionnaire/question_3.dart';
import 'package:app/Pages/Questionnaire/question_5.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionFour extends StatefulWidget {
  QuestionFour({super.key, required this.responses});

  List<String> responses;

  @override
  State<QuestionFour> createState() {
    return _QuestionFourState();
  }
}

class _QuestionFourState extends State<QuestionFour> {
  bool isChecked = false;
  String? financialStatus;
  String? fundraisingExperience;
  late List<String> tempResponses;

  final List<String> financialStatusOptions = [
    'Very stable',
    'Stable',
    'Unstable',
    'Very unstable'
  ];

  final List<String> fundraisingExperienceOptions = [
    'None',
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  @override
  void initState() {
    super.initState();
    tempResponses =
        List.from(widget.responses); // Create a copy of the responses
  }

  void _checkInputtedData() {
    setState(() {
      // Update the state to reflect whether input has been entered
    });
  }

  bool get hasInputtedData {
    return financialStatus != null || fundraisingExperience != null;
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
                    builder: (context) =>
                        QuestionThree(responses: widget.responses)));
          },
        ),
        actions: [
          hasInputtedData
              ? IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (financialStatus != null) {
                      tempResponses.add(financialStatus!);
                    }
                    if (fundraisingExperience != null) {
                      tempResponses.add(fundraisingExperience!);
                    }
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                QuestionFive(responses: tempResponses)));
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
                    style: TextStyle(color: Colors.white),
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
              'What is the current financial status of your organization?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: financialStatus,
              hint: const Text('Select financial status'),
              isExpanded: true,
              items: financialStatusOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  financialStatus = newValue;
                  _checkInputtedData();
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'How much experience do you have in fundraising and grant acquisition?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: fundraisingExperience,
              hint: const Text('Select experience level'),
              isExpanded: true,
              items: fundraisingExperienceOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  fundraisingExperience = newValue;
                  _checkInputtedData();
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Other responses:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(widget.responses.join(', ')),
          ],
        ),
      ),
    );
  }
}
