// ignore_for_file: must_be_immutable

import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:flutter/material.dart';

class QuestionThree extends StatefulWidget {
  QuestionThree({super.key, required this.responses});

  List<String> responses;

  @override
  State<QuestionThree> createState() {
    return _QuestionThreeState();
  }
}

class _QuestionThreeState extends State<QuestionThree> {
  bool isChecked = false;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.responses.join(', ')),
      ),
    );
  }
}
