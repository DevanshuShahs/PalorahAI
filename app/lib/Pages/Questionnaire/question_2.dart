import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_icon/animated_icon.dart';
import 'question_1.dart';
import 'question_3.dart';

class QuestionTwo extends StatefulWidget {
  QuestionTwo({super.key, required this.responses});

  final List<String> responses;
  final List<String> goals = [
    "Organizational Development",
    "Community Engagement",
    "Increased Funding"
  ];

  @override
  State<QuestionTwo> createState() => _QuestionTwoState();
}

class _QuestionTwoState extends State<QuestionTwo> {
  List<bool> isChecked = [false, false, false];
  late List<String> tempResponses;

  @override
  void initState() {
    super.initState();
    tempResponses = List.from(widget.responses);
  }

  void _updateResponses() {
    tempResponses = List.from(widget.responses);
    for (int i = 0; i < widget.goals.length; i++) {
      if (isChecked[i]) {
        tempResponses.add(widget.goals[i]);
      } else {
        tempResponses.remove(widget.goals[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Goals"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _updateResponses();
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => QuestionThree(responses: tempResponses)),
              );
            },
            child: Text(isChecked.contains(true) ? "Next" : "Skip"),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What are your goals?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...List.generate(
                widget.goals.length,
                (index) => CheckboxListTile(
                  title: Text(widget.goals[index]),
                  value: isChecked[index],
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked[index] = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              const SizedBox(height: 20),
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