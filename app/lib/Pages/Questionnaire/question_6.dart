import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:flutter/material.dart';

class QuestionSix extends StatefulWidget {
  QuestionSix({super.key, required this.responses});

  List<String> responses;

  @override
  State<QuestionSix> createState() {
    return _QuestionSixState();
  }
}

class _QuestionSixState extends State<QuestionSix> {
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
