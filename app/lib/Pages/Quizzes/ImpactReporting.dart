import 'package:flutter/material.dart';
import 'package:app/Pages/Navbar/tutorials.dart';

class ImpactReportQuizApp extends StatelessWidget {
  final Function(int, int) onQuizCompleted;

  const ImpactReportQuizApp({Key? key, required this.onQuizCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuizPage(onQuizCompleted: onQuizCompleted);
  }
}

class QuizPage extends StatefulWidget {
  final Function(int, int) onQuizCompleted;

  const QuizPage({Key? key, required this.onQuizCompleted}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Why is it important to create an impact report for a nonprofit?',
      'options': [
        'To comply with legal requirements',
        'To attract more volunteers',
        'To report back on whether the goals were accomplished',
        'To compare with other nonprofits'
      ],
      'correctAnswer': 2,
    },
    {
      'question': 'What should be included at the top of your impact report?',
      'options': [
        'List of donors',
        'Mission statement and what was done to accomplish it',
        'Financial statements',
        'Upcoming events'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'What type of data is important to include in an impact report?',
      'options': [
        'Qualitative data only',
        'Quantitative data only',
        'Both qualitative and quantitative data',
        'Anecdotal stories only'
      ],
      'correctAnswer': 2,
    },
    {
      'question': 'How should you format the layout of your impact report?',
      'options': [
        'Include a cover page, key highlights, and detailed program pages',
        'List all activities from the year in a timeline',
        'Focus solely on financial achievements',
        'Include only pictures and quotes'
      ],
      'correctAnswer': 0,
    },
    {
      'question': 'How can you utilize the impact report after it is created?',
      'options': [
        'Store it in a file and review it next year',
        'Use it as part of your communications plan and share it with stakeholders',
        'Send it to the government for approval',
        'Use it as an internal document only'
      ],
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
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    widget.onQuizCompleted(score, questions.length);
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
            TextButton(
              child: Text('Back to Tutorials'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // This will return to the Tutorial page
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Impact Report Quiz')),
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
