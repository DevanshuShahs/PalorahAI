import 'package:app/Components/info_tooltip.dart';
import 'package:app/Components/progress_bar.dart';
import 'package:flutter/material.dart';
import '../plan.dart';

class QuestionSix extends StatefulWidget {
  final Map<String, String> responses;

  const QuestionSix({super.key, required this.responses});

  @override
  _QuestionSixState createState() => _QuestionSixState();
}

class _QuestionSixState extends State<QuestionSix> {
  List<String> selectedGoals = [];

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

  void toggleSelection(String goal) {
    setState(() {
      if (selectedGoals.contains(goal)) {
        selectedGoals.remove(goal);
      } else {
        selectedGoals.add(goal);
      }
    });
  }

  void _updateResponses() {
    Map<String, String> goalsMap = {};
    for (int i = 0; i < selectedGoals.length; i++) {
      goalsMap["Financial Goal$i"] = selectedGoals[i];
    }
    Map<String, String> newResponses = {...widget.responses, ...goalsMap};
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            Plan(responses: newResponses),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> values = widget.responses.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Goals'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const QuestionnaireProgress(currentStep: 6, totalSteps: 6),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'What are your financial goals for your non-profit organization?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const InfoTooltip(
                      message:
                          'Select all that apply. These goals will help us tailor our recommendations.'),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: financialGoals.map((goal) {
                  final isSelected = selectedGoals.contains(goal);
                  return FilterChip(
                    label: Text(goal, style: const TextStyle(fontSize: 14)),
                    selected: isSelected,
                    onSelected: (selected) {
                      toggleSelection(goal);
                    },
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    backgroundColor:
                        Theme.of(context).chipTheme.backgroundColor,
                    checkmarkColor: Theme.of(context).colorScheme.onSecondary,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text('Selected Goals:',
                  style: Theme.of(context).textTheme.titleMedium),
              Text(selectedGoals.isEmpty
                  ? 'None selected'
                  : selectedGoals.join(", ")),
              const SizedBox(height: 24),
              Text('Other responses:',
                  style: Theme.of(context).textTheme.titleMedium),
              Text(values.join(', ')),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectedGoals.isNotEmpty ? _updateResponses : null,
        backgroundColor: selectedGoals.isNotEmpty ? null : Colors.grey,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
