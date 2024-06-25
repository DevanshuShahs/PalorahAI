import 'package:flutter/material.dart';

// ignore: must_be_immutable
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
      body: SafeArea(
        child: Center(
          child: Text(widget.responses.join(", ")),
        ),
      ),
    );
  }
}
