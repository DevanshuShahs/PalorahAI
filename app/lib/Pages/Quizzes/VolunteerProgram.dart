import 'package:flutter/material.dart';

class VolunteerRecruitmentQuizApp extends StatelessWidget {
  final Function(int, int) onQuizCompleted;

  const VolunteerRecruitmentQuizApp({Key? key, required this.onQuizCompleted}) : super(key: key);

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
      'question': 'Who is the speaker in the video and what is her role?',
      'options': [
        'Jennifer Brown, a nonprofit consultant',
        'Amber Melanie Smith, a nonprofit founder and executive director',
        'Michael Johnson, a volunteer coordinator',
        'Sarah White, a nonprofit board member'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'According to Amber, what is crucial to align volunteer tasks with?',
      'options': [
        'The volunteers\' personal interests',
        'The organization\'s mission and goals',
        'The available budget',
        'The volunteers\' schedules'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'What does Amber suggest doing to accommodate volunteers with busy schedules?',
      'options': [
        'Offering only long-term commitments',
        'Breaking tasks into smaller, shorter commitments',
        'Providing online training sessions',
        'Increasing the number of volunteers'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'How many emails does Amber recommend sending to volunteers, and when should the first email be sent?',
      'options': [
        'Two emails, with the first one sent a week before the event',
        'Three emails, with the first one sent within 48 hours of sign-up',
        'Four emails, with the first one sent immediately after sign-up',
        'One email, with it being sent the day before the event'
      ],
      'correctAnswer': 1,
    },
    {
      'question': 'Why is it important to highlight the impact of volunteers\' tasks, according to Amber?',
      'options': [
        'To justify the organization\'s budget',
        'To inspire and encourage volunteers to continue their service',
        'To compete with other organizations',
        'To attract media attention'
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
      appBar: AppBar(title: Text('Volunteer Recruitment Quiz')),
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
