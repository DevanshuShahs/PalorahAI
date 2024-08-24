import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/Pages/userPlan.dart';
import 'package:app/Pages/landing_page.dart';

class CreatedPlanHomePage extends StatefulWidget {
  const CreatedPlanHomePage({Key? key}) : super(key: key);

  @override
  State<CreatedPlanHomePage> createState() => _CreatedPlanHomePageState();
}

class _CreatedPlanHomePageState extends State<CreatedPlanHomePage> {
  late Stream<QuerySnapshot> _plansStream;
  final PageController _pageController = PageController(viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    _plansStream = _getPlansStream();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> _getPlansStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('plans')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    }
    return Stream.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back arrow

        title: const Text(
          "Your Plans",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _plansStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No plans created yet.'));
          }

          final plans = snapshot.data!.docs;

          return PageView.builder(
            controller: _pageController,
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index].data() as Map<String, dynamic>;
              return _buildPlanCard(plan, plans[index].id, index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LandingPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPlanCard(
      Map<String, dynamic> plan, String planId, int cardIndex) {
    // Alternate colors based on the index
    Color cardColor = cardIndex % 2 == 0
        ? Theme.of(context).colorScheme.surfaceContainerLow.withOpacity(0.9)
        : Color(0xFf7e7e7e);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserPlan(planId: planId)),
        );
      },
      child: Card(
        color: cardColor, // Set the card color
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    plan['planName'] ?? 'Unnamed Plan',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            cardIndex % 2 == 0 ? Colors.black : Colors.white),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editPlanName(planId, plan['planName']);
                    } else if (value == 'delete') {
                      _deletePlan(planId);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: cardIndex % 2 == 0 ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: (plan['plan'] as List?)?.length ?? 0,
                itemBuilder: (context, index) {
                  final step =
                      (plan['plan'] as List)[index] as Map<String, dynamic>;
                  return _buildStepCards(step, cardIndex);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editPlanName(String planId, String? currentName) {
    TextEditingController nameController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Plan Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Enter new plan name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('plans')
                    .doc(planId)
                    .update({'planName': nameController.text});
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deletePlan(String planId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Plan'),
          content: const Text('Are you sure you want to delete this plan?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('plans')
                    .doc(planId)
                    .delete();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStepCards(Map<String, dynamic> step, int index) {
    List<String> substeps = (step['substeps'] as List?)?.cast<String>() ?? [];
    String title = step.isNotEmpty ? step['title'] : 'No title';
    String timeline = substeps.length > 1 ? substeps[1] : 'No timeline';
    title = title.replaceAll('*', '');
    timeline = timeline.replaceAll('*', '');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: index % 2 == 0
          ? Theme.of(context).colorScheme.surfaceContainerLow
          : Color(0xFf7e7e7e).withOpacity(0.8),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: index % 2 == 0 ? Colors.black : Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              timeline,
              style: TextStyle(
                  fontSize: 14,
                  color: index % 2 == 0
                      ? Colors.grey
                      : Colors.white.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
