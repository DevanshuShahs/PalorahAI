import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

class Response {
  final String output;

  Response({required this.output});
}

class Plan extends StatefulWidget {
  Plan({super.key, required this.responses});

  final List<String> responses;

  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  String? story;
  final gemini = Gemini.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchStory(); // Fetch the story when the widget is initialized
  }

  void fetchStory() async {
    try {
      final value = await gemini.text(
          "give a 5 step plan that takes into account these parameters for a person trying to start a nonprofit " +
              widget.responses.join(', '));
      setState(() {
        story = value?.output ?? 'No output';
      });
      savePlanToFirestore(value?.output ?? 'No output');
    } catch (e) {
      setState(() {
        story = 'Error: $e';
      });
    }
  }

  void savePlanToFirestore(String plan) async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await firestore.collection('plans').add({
          'userId': user.uid,
          'plan': plan,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error saving to Firestore: $e');
    }
  }

  Widget buildLoadingScreen() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(6, (index) => buildShimmerPlaceholder()),
      ),
    );
  }

  Widget buildShimmerPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 20.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Plan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (story == null)
                  buildLoadingScreen()
                else
                  Text(
                    story!,
                    style: const TextStyle(fontSize: 12),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
