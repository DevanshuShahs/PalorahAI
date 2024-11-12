import 'package:flutter/material.dart';

class EmailCampaignQuizApp extends StatelessWidget {
  final Function(int, int) onQuizCompleted;

  const EmailCampaignQuizApp({Key? key, required this.onQuizCompleted}) : super(key: key);

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
      'question': 'What is considered the best way to keep donors informed for a nonprofit?',
      'options': ['Social media marketing', 'Email marketing', 'Direct mail campaigns', 'Phone calls'],
      'correctAnswer': 1,
    },
    {
      'question': 'Which email service provider (ESP) is recommended for advanced automation and a full CRM?',
      'options': ['Mailchimp', 'Constant Contact', 'HubSpot', 'MailerLite'],
      'correctAnswer': 2,
    },
    {
      'question': 'What should you avoid when building your email list for a nonprofit?',
      'options': ['Collecting first and last names separately', 'Renting or buying an email list from a third party', 'Using a pop-up form on your website', 'Partnering with another nonprofit to share lists'],
      'correctAnswer': 1,
    },
    {
      'question': 'What is considered the most important element in an email that determines whether it will be opened or not?',
      'options': ['The sender\'s name', 'The email design', 'The subject line', 'The call to action buttons'],
      'correctAnswer': 2,
    },
    {
      'question': 'How often should a nonprofit generally send email newsletters, according to the video?',
      'options': ['Daily', 'Once a week or once a month', 'Every six months', 'Only during fundraising campaigns'],
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
      appBar: AppBar(title: Text('Email Campaign Quiz')),
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
