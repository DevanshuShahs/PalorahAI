import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/authentication.dart';

import '../Components/custom_button.dart';
import '../Components/animated_logo.dart';
import '../Components/animated_circle.dart';
import 'createdPlanHomePage.dart';

class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ChangeNotifierProvider(
        create: (_) => UserPlanProvider(),
        child: Consumer<UserPlanProvider>(
          builder: (context, userPlanProvider, _) {
            if (userPlanProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (userPlanProvider.hasExistingPlan) {
              return const CreatedPlanHomePage();
            }
            return Stack(
              children: [
                _buildContent(context),
                AnimatedLogo(),
                AnimatedCircle(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Build an organization without limits',
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Build and scale with confidence. From a powerful financial advisor to advanced organization solutions—we've got you covered",
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        QuestionOne(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
