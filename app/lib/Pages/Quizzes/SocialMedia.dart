import 'package:flutter/material.dart';
import 'package:app/Pages/Navbar/tutorials.dart';

class GrantProposalQuizApp extends StatelessWidget {
  final Function(int, int) onQuizCompleted;

  const GrantProposalQuizApp({Key? key, required this.onQuizCompleted}) : super(key: key);

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
      'question': 'What is the first strategy mentioned for nonprofits to succeed on social media?',
      'options': ['Regular Posting', 'Audience Engagement', 'Visual Storytelling', 'Fundraising Campaigns'],
      'correctAnswer': 2,
    },
    {
      'question': 'Why is it important for nonprofits to use storytelling in their social media strategy?',
      'options': ['To increase post frequency', 'To create an emotional connection with the audience', 'To generate more likes and shares', 'To reduce advertising costs'],
      'correctAnswer': 1,
    },
    {
      'question': 'What does the video suggest about the frequency of posting on social media for nonprofits?',
      'options': ['Post once a week', 'Post daily', 'Post multiple times a day', 'Post only during campaigns'],
      'correctAnswer': 1,
    },
    {
      'question': 'Which platform is highlighted as particularly useful for nonprofit visual storytelling?',
      'options': ['Facebook', 'Instagram', 'LinkedIn', 'Twitter'],
      'correctAnswer': 1,
    },
    {
      'question': 'What is the main benefit of using analytics tools for nonprofit social media efforts, according to the video?',
      'options': ['To increase follower count', 'To understand and improve audience engagement', 'To automate posts', 'To reduce content creation time'],
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
      appBar: AppBar(title: Text('Social Media Quiz')),
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