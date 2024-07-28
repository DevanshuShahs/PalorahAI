import 'package:flutter/material.dart';

class GrantProposalQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grant Proposal Quiz',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the first section of a grant proposal that the grant maker reads?',
      'options': ['Organization Background', 'Executive Summary', 'Need Statement', 'Budget'],
      'correctAnswer': 1,
    },
    {
      'question': 'Which section showcases your organization\'s credibility and authority?',
      'options': ['Executive Summary', 'Organization Background', 'Project Description', 'Evaluation Plan'],
      'correctAnswer': 1,
    },
    {
      'question': 'In which section do you paint a compelling picture of the problem your organization aims to solve?',
      'options': ['Need Statement', 'Project Description', 'Budget', 'Sustainability Plan'],
      'correctAnswer': 0,
    },
    {
      'question': "What's the difference between outputs and outcomes?",
      'options': [
        'Outputs are the results, outcomes are the actions',
        'Outputs are the actions, outcomes are the changes',
        'They are the same thing',
        'Outputs are short-term, outcomes are long-term'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'What percentage of your programs budget should you typically not exceed when asking for funding from a single funder?',
      'options': ['10-20%', '30-40%', '50-60%', '70-80%'],
      'correctAnswer': 1,
    },
  ];

  int currentQuestionIndex = 0;
  int score = 0;

  void checkAnswer(int selectedIndex) {
    if (selectedIndex == questions[currentQuestionIndex]['correctAnswer']) {
      setState(() {
        score++;
      });
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Completed'),
            content: Text('Your score: $score out of ${questions.length}'),
            actions: [
              TextButton(
                child: Text('Restart'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    currentQuestionIndex = 0;
                    score = 0;
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grant Proposal Quiz')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              questions[currentQuestionIndex]['question'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...(questions[currentQuestionIndex]['options'] as List<String>).asMap().entries.map((entry) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  child: Text(entry.value),
                  onPressed: () => checkAnswer(entry.key),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            Text('Score: $score / ${questions.length}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}