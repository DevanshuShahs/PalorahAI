import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

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
    } catch (e) {
      setState(() {
        story = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Response Screen'),
      ),
      body: SafeArea(
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
              const Text(
                'Responses:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
    );
  }
}
