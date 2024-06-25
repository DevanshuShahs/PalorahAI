import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  String story = "**Loading...**";
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
                Text(
                  story,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: widget.responses.length,
                //     itemBuilder: (context, index) {
                //       return ListTile(
                //         title: Text(widget.responses[index]),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
