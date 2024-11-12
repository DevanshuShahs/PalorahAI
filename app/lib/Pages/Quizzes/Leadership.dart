import 'package:flutter/material.dart';

class LeadershipQuizApp extends StatelessWidget {
  final Function(int, int) onQuizCompleted;

  const LeadershipQuizApp({Key? key, required this.onQuizCompleted}) : super(key: key);

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
      'question': 'What is one key trait of effective leadership?',
      'options': ['Micromanaging', 'Indecisiveness', 'Empathy', 'Detachment'],
      'correctAnswer': 2,
    },
    {
      'question': 'Which leadership style involves making decisions unilaterally?',
      'options': ['Democratic', 'Laissez-faire', 'Transformational', 'Autocratic'],
      'correctAnswer': 3,
    },
    {
      'question': 'Why is communication important in leadership?',
      'options': ['To show authority', 'To avoid making decisions', 'To build trust and clarity', 'To reduce the need for meetings'],
      'correctAnswer': 2,
    },
    {
      'question': 'What is a primary focus of transformational leaders?',
      'options': ['Maintaining the status quo', 'Encouraging innovation and change', 'Enforcing strict rules', 'Reducing employee feedback'],
      'correctAnswer': 1,
    },
    {
      'question': 'Which quality is essential for building effective teams?',
      'options': ['Flexibility', 'Isolation', 'Ego', 'Dominance'],
      'correctAnswer': 0,
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
      appBar: AppBar(title: Text('Leadership Quiz')),
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
