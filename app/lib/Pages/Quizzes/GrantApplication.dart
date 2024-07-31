import 'package:flutter/material.dart';
import 'package:app/Pages/Navbar/tutorials.dart';

class GrantApplicationQuizApp extends StatelessWidget {
  final Function(int, int) onQuizCompleted;

  const GrantApplicationQuizApp({Key? key, required this.onQuizCompleted}) : super(key: key);

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
      'question': 'What was the main obstacle the speaker faced when trying to get grants for her nonprofit?',
      'options': [
        'Lack of nonprofit status',
        'The long and complicated application process',
        'Inadequate funding opportunities',
        'Unqualified staff'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'What did the speaker learn that helped her successfully apply for grants?',
      'options': [
        'How to hire an expensive grant writer',
        'How to find grants targeted to brand new nonprofits',
        'How to create a detailed financial audit',
        'How to build a five-year track record'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'How many grants has the speaker\'s nonprofit successfully won using the new strategies?',
      'options': [
        'Three grants',
        'Five grants',
        'Ten grants',
        'Fifteen grants'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'What is the first strategy covered in the speaker\'s training for obtaining grants?',
      'options': [
        'How to hire a professional grant writer',
        'How to find grants that match your nonprofit’s mission in 15 minutes',
        'How to prepare audited financial statements',
        'How to build a five-year operational track record'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'What is the main benefit of the training program mentioned by the speaker?',
      'options': [
        'It helps secure million-dollar grants',
        'It teaches how to write grant applications in 20 minutes',
        'It reduces the cost of hiring grant writers',
        'It provides legal advice for nonprofit operations'
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
      appBar: AppBar(title: Text('Grant Application Quiz')),
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
