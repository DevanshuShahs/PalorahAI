import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:shimmer/shimmer.dart';

import '../../Services/authentication.dart';

class DonorDraft extends StatefulWidget {
  const DonorDraft({Key? key}) : super(key: key);

  @override
  State<DonorDraft> createState() => _DonorDraftState();
}

class _DonorDraftState extends State<DonorDraft> {
  final gemini = Gemini.instance;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _keyPointsController = TextEditingController();
  String _generatedEmail = '';
  bool _isLoading = false;
  String _selectedTone = 'Professional';
  String _organizationName = '';
  late Future<String> _userNameFuture;

  final List<String> _tones = ['Professional', 'Friendly', 'Formal', 'Casual'];

  @override
  void initState() {
    super.initState();
    _userNameFuture = fetchUserName();
  }

  void _generateEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Await the future to get the actual user name
      String userName = await _userNameFuture;

      String prompt = """
Generate an email for $userName. These are their requirements:
Subject: ${_subjectController.text}
Key Points that need to be incorporated: ${_keyPointsController.text}
Please use a $_selectedTone tone when writing.
Their organization is called $userName, please use this in your conclusion.

Please write a well-structured email incorporating these elements and mentioning the organization name (${_organizationName}) appropriately.
""";

      final response = await gemini.text(prompt);

      if (response != null && response.output != null) {
        setState(() {
          _generatedEmail = response.output!;
          _isLoading = false;
        });
      } else {
        throw Exception('No output from Gemini');
      }
    } catch (e) {
      setState(() {
        _generatedEmail = 'Error generating email: $e';
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedEmail));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email copied to clipboard')),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Email Writer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _keyPointsController,
              decoration: const InputDecoration(
                labelText: 'Key Points',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTone,
              decoration: const InputDecoration(
                labelText: 'Tone',
                border: OutlineInputBorder(),
              ),
              items: _tones.map((String tone) {
                return DropdownMenuItem<String>(
                  value: tone,
                  child: Text(tone),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTone = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateEmail,
              child: const Text('Generate Email'),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              _buildShimmerPlaceholder()
            else if (_generatedEmail.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_generatedEmail),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _copyToClipboard,
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _generateEmail,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Regenerate'),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
