import 'package:app/Components/password_input.dart';
import 'package:flutter/material.dart';
import 'package:app/Pages/landing_page.dart';
import 'package:app/Pages/login_page.dart';
import 'package:app/Services/authentication.dart';
import 'package:app/Components/button.dart';
import 'package:app/Components/text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signupUser() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text;
    String password = passwordController.text;

    if (!email.endsWith('@gmail.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email must be a Gmail address.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters long.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    String res = await AuthMethod().signupUser(
      email: email,
      password: password,
      name: nameController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (res == "success") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LandingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "PalorahAI",
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primaryGreen,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Create your account",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFieldInput(
                                icon: Icons.groups,
                                textEditingController: nameController,
                                hintText: "Enter organization's name",
                                textInputType: TextInputType.text,
                                fillColor: primaryGreen.withOpacity(0.1),
                                iconColor: primaryGreen,
                              ),
                              const SizedBox(height: 16),
                              TextFieldInput(
                                icon: Icons.email,
                                textEditingController: emailController,
                                hintText: 'Enter your email',
                                textInputType: TextInputType.emailAddress,
                                fillColor: primaryGreen.withOpacity(0.1),
                                iconColor: primaryGreen,
                              ),
                              const SizedBox(height: 16),
                              PasswordInput(
                                icon: Icons.lock,
                                textEditingController: passwordController,
                                hintText: 'Enter your password',
                                textInputType: TextInputType.text,
                                fillColor: primaryGreen.withOpacity(0.1),
                                iconColor: primaryGreen,
                              ),
                              const SizedBox(height: 24),
                              MyButtons(
                                onTap: signupUser,
                                text: isLoading ? "Signing up..." : "Sign Up",
                                backgroundColor: primaryGreen,
                                textColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _loginOption(primaryGreen),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signupUser,
        backgroundColor: primaryGreen,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _loginOption(Color primaryGreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Look familiar?",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 22),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          },
          child: Text(
            "Log in",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: primaryGreen,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
      ],
    );
  }
}