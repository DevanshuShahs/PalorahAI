import 'package:flutter/material.dart';
import 'package:app/Pages/Navbar/tutorials.dart';

class EventPlanningQuizApp extends StatelessWidget {
  final Function(int, int) onQuizCompleted;

  const EventPlanningQuizApp({Key? key, required this.onQuizCompleted}) : super(key: key);

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
      'question': 'What is the ideal amount of time to plan a nonprofit event?',
      'options': ['One month', 'Three months', 'Six months to a year', 'Two years'],
      'correctAnswer': 2,
    },
    {
      'question': 'What should you consider first when developing a strategy for an event?',
      'options': ['The event location', 'The event date', 'Why you want to plan the event', 'The event theme'],
      'correctAnswer': 2,
    },
    {
      'question': 'What is recommended when developing a proposed event budget?',
      'options': ['Underestimate costs to stay within budget', 'Obtain actual quotes and overestimate costs', 'Avoid budgeting for staff time', 'Ignore potential in-kind donations'],
      'correctAnswer': 1,
    },
    {
      'question': 'What is one of the primary responsibilities of board and committee members in event planning?',
      'options': ['Choosing the color of tablecloths', 'Bringing in revenue and securing sponsorship deals', 'Handling event logistics', 'Designing event invitations'],
      'correctAnswer': 1,
    },
    {
      'question': 'What crucial business aspect should be handled when planning an event?',
      'options': ['Finalizing decor elements', 'Writing and signing contracts and obtaining permits', 'Posting on social media', 'Designing promotional materials'],
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
      appBar: AppBar(title: Text('Event Planning Quiz')),
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
