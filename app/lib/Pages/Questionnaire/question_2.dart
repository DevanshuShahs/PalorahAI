import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:flutter/material.dart';

class QuestionTwo extends StatefulWidget {
  QuestionTwo({super.key, required this.responses});

  List<String> responses;

  @override
  State<QuestionTwo> createState() {
    return _QuestionTwoState();
  }
}

class _QuestionTwoState extends State<QuestionTwo> {
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
