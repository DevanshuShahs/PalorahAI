import 'package:flutter/material.dart';

class BrandingDesignQuizApp extends StatelessWidget {
  final Function(int, int) onQuizCompleted;

  const BrandingDesignQuizApp({Key? key, required this.onQuizCompleted}) : super(key: key);

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
      'question': 'What is the first step in creating practical brand guidelines for a nonprofit?',
      'options': ['Choosing your color palette', 'Establishing your tone of voice', 'Designing your logo', 'Creating a design library'],
      'correctAnswer': 1,
    },
    {
      'question': 'What should you consider when establishing your tone of voice?',
      'options': ['The organization\'s history', 'The organization\'s budget', 'Who your target audience is', 'The organization\'s location'],
      'correctAnswer': 2,
    },
    {
      'question': 'Why is a visual identity important for a nonprofit?',
      'options': ['It helps with budgeting', 'It makes the organization recognizable and sets it apart from competition', 'It simplifies the donation process', 'It reduces the need for marketing materials'],
      'correctAnswer': 1,
    },
    {
      'question': 'What is recommended for organizing a design library?',
      'options': ['Creating a master folder for all assets', 'Keeping all files in one folder without subfolders', 'Storing only recent projects', 'Avoiding backups to save space'],
      'correctAnswer': 0,
    },
    {
      'question': 'Why is it important for all team members, including volunteers, to be familiar with the brand guidelines?',
      'options': ['To ensure they can design logos independently', 'To maintain a consistent look and feel across all channels', 'To allow them to create their own guidelines', 'To enable them to manage the budget effectively'],
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
      appBar: AppBar(title: Text('Branding and Design Quiz')),
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
