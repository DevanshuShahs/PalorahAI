// ignore_for_file: must_be_immutable

import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class QuestionThree extends StatefulWidget {
  QuestionThree({super.key, required this.responses});

  List<String> responses;

  @override
  State<QuestionThree> createState() {
    return _QuestionThreeState();
  }
}


class _QuestionThreeState extends State<QuestionThree> {
  final gemini = Gemini.instance;
  bool isChecked = false;
  String story = "Loading...";

  @override
  void initState() {
    super.initState();
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(story),
      ),
    );
  }
}


// return Scaffold(
//       body: Center(
//         child: Text(widget.responses.join(', ')),
//       ),
//     );