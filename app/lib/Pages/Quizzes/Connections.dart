import 'package:flutter/material.dart';
import 'package:app/Pages/Navbar/tutorials.dart';

class ConnectionsQuizApp extends StatelessWidget {
  final Function(int, int) onQuizCompleted;

  const ConnectionsQuizApp({Key? key, required this.onQuizCompleted}) : super(key: key);

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
      'question': 'What is the primary purpose of creating connections in networking?',
      'options': ['To increase social media followers', 'To build meaningful professional relationships', 'To promote products and services', 'To gain financial benefits'],
      'correctAnswer': 1,
    },
    {
      'question': 'Which platform is considered most effective for professional networking?',
      'options': ['Facebook', 'Instagram', 'LinkedIn', 'Twitter'],
      'correctAnswer': 2,
    },
    {
      'question': 'What should be your main focus when attending networking events?',
      'options': ['Collecting as many business cards as possible', 'Promoting your business', 'Listening and learning about others', 'Handing out your resume'],
      'correctAnswer': 2,
    },
    {
      'question': 'Why is follow-up important after making a new connection?',
      'options': ['To remind them of your meeting', 'To secure immediate business deals', 'To build and maintain the relationship', 'To send promotional materials'],
      'correctAnswer': 2,
    },
    {
      'question': 'What is a good strategy for expanding your professional network?',
      'options': ['Only connect with people in your field', 'Attend various industry events and conferences', 'Limit connections to friends and family', 'Focus solely on online networking'],
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
      appBar: AppBar(title: Text('Connections Quiz')),
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
