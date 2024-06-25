import 'package:app/Pages/plan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuestionSix extends StatefulWidget {
  QuestionSix({super.key, required this.responses});

  List<String> responses;

  @override
  State<QuestionSix> createState() {
    return _QuestionSixState();
  }
}

class _QuestionSixState extends State<QuestionSix> {
  List<String> selectedGoals = [];
  late List<String> tempResponses;

  final List<String> financialGoals = [
    'Increase Donations',
    'Secure Grants',
    'Reduce Expenses',
    'Build Reserves',
    'Diversify Funding',
    'Expand Donors',
    'Financial Transparency',
    'Fundraising Events',
    'Endowment Fund',
    'Increase Membership',
    'Financial Reporting',
    'Invest Technology',
    'Hire Staff',
    'Cost Efficiency',
    'Long-term Sustainability',
    'Financial Policies',
    'Manage Debt',
    'Program Funding',
    'Financial Training',
    'Maximize Impact'
  ];

  @override
  void initState() {
    super.initState();
    tempResponses = List.from(widget.responses);
  }

  void toggleSelection(String goal) {
    setState(() {
      if (selectedGoals.contains(goal)) {
        selectedGoals.remove(goal);
      } else {
        selectedGoals.add(goal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Financial Goals'),
        actions: [
          TextButton(
            onPressed: () {
              tempResponses.addAll(selectedGoals);
              // Navigate to the next screen or perform an action
              Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                Plan(responses: tempResponses)));
            },
            child: const Text(
              'Next',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'What are your financial goals for your non-profit organization? (Select all that apply)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: financialGoals.map((goal) {
                      final isSelected = selectedGoals.contains(goal);
                      return FilterChip(
                        label: Text(goal, style: const TextStyle(fontSize: 12),),
                        selected: isSelected,
                        onSelected: (selected) {
                          toggleSelection(goal);
                        },
                        selectedColor: Colors.greenAccent,
                        backgroundColor: Colors.grey[200],
                        checkmarkColor: Colors.white,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Selected Goals: ${selectedGoals.join(", ")}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
