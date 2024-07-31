import 'package:app/Components/password_input.dart';
import 'package:app/Pages/Navbar/homepage.dart';
import 'package:flutter/material.dart';
import 'package:app/Pages/sign_up.dart';
import 'package:app/Services/authentication.dart';
import 'package:app/Components/button.dart';
import 'package:app/Components/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethod().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Homepage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email or password is incorrect.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Login'),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: primaryGreen,
                                        fontSize: 45),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Welcome back",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                onTap: loginUser,
                                text: isLoading ? "Logging in..." : "Log In",
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
                              _signUpOption(primaryGreen),
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
        onPressed: loginUser,
        backgroundColor: primaryGreen,
        child: const Icon(Icons.login),
      ),
    );
  }

  Widget _signUpOption(Color primaryGreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "First time?",
          style:
              Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 25),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SignUpPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          },
          child: Text(
            "Sign up",
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
