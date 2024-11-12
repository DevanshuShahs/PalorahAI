import 'package:flutter/material.dart';

class FundraisingQuizApp extends StatelessWidget {
  final Function(int, int) onQuizCompleted;

  const FundraisingQuizApp({Key? key, required this.onQuizCompleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FundraisingQuizPage(onQuizCompleted: onQuizCompleted);
  }
}

class FundraisingQuizPage extends StatefulWidget {
  final Function(int, int) onQuizCompleted;

  const FundraisingQuizPage({Key? key, required this.onQuizCompleted}) : super(key: key);

  @override
  _FundraisingQuizPageState createState() => _FundraisingQuizPageState();
}

class _FundraisingQuizPageState extends State<FundraisingQuizPage> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the first step in planning a successful fundraising event?',
      'options': ['Setting a budget', 'Identifying a target audience', 'Choosing a venue', 'Defining a clear goal'],
      'correctAnswer': 3,
    },
    {
      'question': 'Why is it important to identify your target audience for a fundraising campaign?',
      'options': ['To create generic content', 'To tailor your message and approach', 'To increase the budget', 'To reduce the number of donors'],
      'correctAnswer': 1,
    },
    {
      'question': 'What is a common mistake to avoid in fundraising?',
      'options': ['Personalizing donor communication', 'Setting realistic goals', 'Not following up with donors', 'Using multiple channels to reach donors'],
      'correctAnswer': 2,
    },
    {
      'question': 'Which fundraising method is highlighted as being particularly effective for reaching younger donors?',
      'options': ['Direct mail', 'Phone calls', 'Social media campaigns', 'Television ads'],
      'correctAnswer': 2,
    },
    {
      'question': 'What is the main benefit of using donor management software?',
      'options': ['To increase donation amounts', 'To streamline the donation process', 'To automate social media posts', 'To better understand donor behavior and preferences'],
      'correctAnswer': 3,
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
      appBar: AppBar(title: Text('Fundraising Quiz')),
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
