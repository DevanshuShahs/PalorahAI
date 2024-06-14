import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:flutter/material.dart';

class QuestionFive extends StatefulWidget {
  QuestionFive({super.key, required this.responses});

  List<String> responses;

  @override
  State<QuestionFive> createState() {
    return _QuestionFiveState();
  }
}

class _QuestionFiveState extends State<QuestionFive> {
  bool isChecked = false;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.responses[0]),
      ),
    );
  }
}
