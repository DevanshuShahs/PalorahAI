import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const Myhelper());
}

class Myhelper extends StatelessWidget {
  const Myhelper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _messageController;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final userMessage = _messageController.text;
      setState(() {
        _messages.insert(0, {
          'text': userMessage,
          'isUserMessage': true,
        });
      });

      try {
        final apikey = 'AIzaSyDfBHY0jBXU89_HgdQi0ZtuPCMvXIBqnhY';
        final model = GenerativeModel(model: "gemini-pro", apiKey: apikey);
        final content = Content.text(userMessage);
        final response = await model.generateContent([content]);

        setState(() {
          _messages.insert(0, {
            'text': response.text,
            'isUserMessage': false,
          });
        });
      } catch (e) {
        _addSystemMessage("Failed to get response: $e");
      }

      _messageController.clear();
    }
  }

  void _addSystemMessage(String text) {
    setState(() {
      _messages.insert(0, {
        'text': text,
        'isUserMessage': false,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Helper"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  var message = _messages[index];
                  return Align(
                    alignment: message['isUserMessage'] ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: message['isUserMessage'] ? Colors.green[300] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(color: message['isUserMessage'] ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "How Can I Help You?",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}