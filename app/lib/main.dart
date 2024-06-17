import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:app/Pages/home_page.dart';
import 'package:app/Pages/login_page.dart';
import 'package:app/Pages/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Fonts',
      // Set Raleway as the default app font.
      theme: ThemeData(fontFamily: 'Poppins'),
      initialRoute: "/login",
      routes: {
        "/signUp":(context) => signUpPage(),
        "/login": (context) => loginPage(),
        "/home": (context) => homePage(),
        "/Question1": (context) => QuestionOne(),
      },
    );
  }
}
