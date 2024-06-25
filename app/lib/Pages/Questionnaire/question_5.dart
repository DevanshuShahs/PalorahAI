import 'package:app/Pages/Plan.dart';
import 'package:app/Pages/Questionnaire/question_4.dart';
import 'package:app/Pages/Questionnaire/question_6.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuestionFive extends StatefulWidget {
  QuestionFive({super.key, required this.responses});

  List<String> responses;

  @override
  State<QuestionFive> createState() {
    return _QuestionFiveState();
  }
}

class _QuestionFiveState extends State<QuestionFive> {
  String? membershipCount;
  String? organizationStructure;
  late List<String> tempResponses;

  @override
  void initState() {
    super.initState();
    tempResponses = List.from(widget.responses); // Create a copy of the responses
  }

  void _checkInputtedData() {
    setState(() {
      // This function will call setState to update the UI
    });
  }

  bool get hasInputtedData {
    return membershipCount != null && membershipCount!.isNotEmpty || organizationStructure != null && organizationStructure!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
                    widget.responses.clear();
            widget.responses.add("useInitState");
            Navigator.pop(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        QuestionFour(responses: widget.responses))
                );
          },
        ),
        actions: [
          hasInputtedData
              ? IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (membershipCount != null && membershipCount!.isNotEmpty) {
                      tempResponses.add(membershipCount!);
                    }
                    if (organizationStructure != null && organizationStructure!.isNotEmpty) {
                      tempResponses.add(organizationStructure!);
                    }
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                Plan(responses: tempResponses))); // Replace NextScreen with the actual next screen class
                  },
                )
              : TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                QuestionSix(responses: widget.responses))); // Replace NextScreen with the actual next screen class
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
              'What is the current membership count of your organization?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter membership count here...',
              ),
              onChanged: (text) {
                setState(() {
                  membershipCount = text;
                  _checkInputtedData();
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'What is the organization structure of your non-profit?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter organization structure here...',
              ),
              onChanged: (text) {
                setState(() {
                  organizationStructure = text;
                  _checkInputtedData();
                });
              },
            ),
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
