import 'package:app/Pages/Questionnaire/question_3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionTwo extends StatefulWidget {
  QuestionTwo({super.key, required this.responses});

  List<String> responses;
  String checkbox1 = "You are batman";
  String checkbox2 = "You are superman";

  @override
  State<QuestionTwo> createState() {
    return _QuestionTwoState();
  }
}

class _QuestionTwoState extends State<QuestionTwo> {
  bool isChecked1 = false;
  bool isChecked2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              //Submit responses button
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            QuestionThree(responses: widget.responses)));
              },
              child: Text("Next"),
            ),
            Row(
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
                Text("I am batman")
              ],
            ),
            Row(
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
                Text("I am superman")
              ],
            )
          ],
        ),
      ),
    );
  }
}
