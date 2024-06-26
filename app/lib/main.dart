import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:app/Pages/home_page.dart';
import 'package:app/Pages/login_page.dart';
import 'package:app/Pages/sign_up.dart';
import 'package:app/api/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  Gemini.init(apiKey: 'AIzaSyDfBHY0jBXU89_HgdQi0ZtuPCMvXIBqnhY');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
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
      navigatorKey: navigatorKey,
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
