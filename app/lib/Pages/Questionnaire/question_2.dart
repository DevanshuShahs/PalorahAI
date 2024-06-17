// ignore_for_file: must_be_immutable

import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:app/Pages/Questionnaire/question_3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionTwo extends StatefulWidget {
  QuestionTwo({super.key, required this.responses});

  List<String> responses;
  String checkbox1 = "Organizational Development";
  String checkbox2 = "Community Engagement";
  String checkbox3 = "Increased funding";

  @override
  State<QuestionTwo> createState() {
    return _QuestionTwoState();
  }
}

class _QuestionTwoState extends State<QuestionTwo> {
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  //Submit responses button
                  onPressed: () {
                    widget.responses.clear();
                    Navigator.pop(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => QuestionOne()));
                  },
                  child: const Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  //Submit responses button
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                QuestionThree(responses: widget.responses)));
                  },
                  child: const Icon(
                    Icons.arrow_right_alt,
                    size: 36,
                  ),
                ),
              ],
            ),
            const Center(
                child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "What are your goals?",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
            )),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.95,
              child: Row(
                children: [
                  Checkbox.adaptive(
                    //Check your answer
                    value: isChecked1,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked1 = !isChecked1;
                      });
                      isChecked1
                          ? widget.responses.add(widget.checkbox1)
                          : widget.responses.remove(widget.checkbox1);
                    },
                  ),
                  const Text(
                    "Organizational Development",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.95,
              child: Row(
                children: [
                  Checkbox.adaptive(
                    //Check your answer
                    value: isChecked2,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked2 = !isChecked2;
                      });
                      isChecked2
                          ? widget.responses.add(widget.checkbox2)
                          : widget.responses.remove(widget.checkbox2);
                    },
                  ),
                  const Text(
                    "Community Engagement",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.95,
              child: Row(
                children: [
                  Checkbox.adaptive(
                    //Check your answer
                    value: isChecked3,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked3 = !isChecked3;
                      });
                      isChecked3
                          ? widget.responses.add(widget.checkbox3)
                          : widget.responses.remove(widget.checkbox3);
                    },
                  ),
                  const Text(
                    "Increased Funding",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
