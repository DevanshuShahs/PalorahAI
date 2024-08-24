import 'package:app/Components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      _showDialog('Success', 'Password reset link sent! Please check your email.');
    } on FirebaseAuthException catch (e) {
      _showDialog('Error', e.message ?? 'An error occurred');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
        title: Text('Forgot Password'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.lock_reset,
                size: 80,
                color: primaryGreen,
              ),
              SizedBox(height: 24),
              Text(
                'Forgot your password?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Enter your email and we will send you a password reset link',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 32),
              TextFieldInput(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                fillColor: primaryGreen.withOpacity(0.1),
                iconColor: primaryGreen,
              ),
              SizedBox(height: 24),
              ElevatedButton(
  onPressed: passwordReset,
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(
      'Reset Password',
      style: TextStyle(
        fontSize: 18,
        color: Colors.white, // Explicitly set text color to white
      ),
    ),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryGreen,
    foregroundColor: Colors.white, // Set the foreground (text and icon) color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}