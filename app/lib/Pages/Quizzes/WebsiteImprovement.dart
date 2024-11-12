import 'package:flutter/material.dart';

class NonprofitWebsiteQuizApp extends StatelessWidget {
  final Function(int, int) onQuizCompleted;

  const NonprofitWebsiteQuizApp({Key? key, required this.onQuizCompleted}) : super(key: key);

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
      'question': 'What is the first characteristic of a great non-profit website mentioned in the video?',
      'options': ['Easy navigation', 'Compelling, quality images', 'Strong call to action', 'Professional design'],
      'correctAnswer': 1,
    },
    {
      'question': 'What should a bold homepage statement include?',
      'options': ['Detailed history of the organization', 'The organization’s mission, a key statistic, or impacts', 'Contact information and address', 'Links to social media pages'],
      'correctAnswer': 1,
    },
    {
      'question': 'Why is it important to show the people behind the organization on the website?',
      'options': ['To make the website look more professional', 'To establish trust with potential donors and supporters', 'To fill up space on the about page', 'To comply with legal requirements'],
      'correctAnswer': 1,
    },
    {
      'question': 'What should a non-profit website include to build public trust and attract future donors?',
      'options': ['A detailed organizational chart', 'Information about the organization’s impacts and results', 'Links to other non-profit organizations', 'A list of all donors'],
      'correctAnswer': 1,
    },
    {
      'question': 'What is a key feature that makes a donation page effective according to the video?',
      'options': ['It has a lot of text explaining the donation process', 'It is easy to find and navigate', 'It uses advanced payment methods', 'It requires users to create an account'],
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
      appBar: AppBar(title: Text('Nonprofit Website Quiz')),
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
