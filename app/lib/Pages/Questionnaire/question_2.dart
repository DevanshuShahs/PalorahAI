// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_icon/animated_icon.dart';
import 'question_1.dart';
import 'question_3.dart';

class QuestionTwo extends StatefulWidget {
  QuestionTwo({super.key, required this.responses});

  List<String> responses;
  String checkbox1 = "Organizational Development";
  String checkbox2 = "Community Engagement";
  String checkbox3 = "Increased Funding";

  @override
  State<QuestionTwo> createState() {
    return _QuestionTwoState();
  }
}

class _QuestionTwoState extends State<QuestionTwo> {
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  late List<String> tempResponses;

  @override
  void initState() {
    super.initState();
    tempResponses = List.from(widget.responses); // Create a copy of the responses
  }

  void _updateResponses() {
    tempResponses = List.from(widget.responses); // Reset tempResponses to the original
    if (isChecked1) {
      tempResponses.add(widget.checkbox1);
    } else {
      tempResponses.remove(widget.checkbox1);
    }
    if (isChecked2) {
      tempResponses.add(widget.checkbox2);
    } else {
      tempResponses.remove(widget.checkbox2);
    }
    if (isChecked3) {
      tempResponses.add(widget.checkbox3);
    } else {
      tempResponses.remove(widget.checkbox3);
    }
  }

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
                  onPressed: () {
                    Navigator.pop(context, CupertinoPageRoute(builder: (context) => QuestionOne()));
                  },
                  child: const Text(
                    "Back",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (isChecked1 || isChecked2 || isChecked3) {
                      _updateResponses();
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => QuestionThree(responses: tempResponses)),
                      );
                    } else {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => QuestionThree(responses: widget.responses)),
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      Visibility(
                        visible: (isChecked1 || isChecked2 || isChecked3),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: AnimateIcon(
                            key: UniqueKey(),
                            onTap: () {
                              _updateResponses();
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => QuestionThree(responses: tempResponses)),
                              );
                            },
                            iconType: IconType.continueAnimation,
                            height: 40,
                            width: 40,
                            animateIcon: AnimateIcons.downArrow,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (!isChecked1 && !isChecked2 && !isChecked3),
                        child: const Text(
                          "Skip",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
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
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Row(
                children: [
                  Checkbox.adaptive(
                    value: isChecked1,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked1 = value ?? false;
                      });
                    },
                  ),
                  const Text(
                    "Organizational Development",
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Row(
                children: [
                  Checkbox.adaptive(
                    value: isChecked2,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked2 = value ?? false;
                      });
                    },
                  ),
                  const Text(
                    "Community Engagement",
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Row(
                children: [
                  Checkbox.adaptive(
                    value: isChecked3,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked3 = value ?? false;
                      });
                    },
                  ),
                  const Text(
                    "Increased Funding",
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            ),
            Center(
              child: const Text(
                'Other responses:',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(widget.responses.join(', ')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
