import 'package:app/Pages/Questionnaire/question_1.dart';
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
