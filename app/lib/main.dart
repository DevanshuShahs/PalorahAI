import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:app/Pages/landing_page.dart';
import 'package:app/Pages/login_page.dart';
import 'package:app/Pages/sign_up.dart';
import 'package:app/notificationApi/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Initialize Gemini (assuming it's correct and required for your app)
  Gemini.init(apiKey: 'AIzaSyDfBHY0jBXU89_HgdQi0ZtuPCMvXIBqnhY');

  // Ensure all bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    // Catch and print any errors that occur during Firebase initialization
    print('Error initializing Firebase: $e');
  }

  // Initialize Firebase Notifications
  try {
    await FirebaseApi().initNotifications();
    print('Firebase notifications initialized successfully');
  } catch (e) {
    // Catch and print any errors during notification initialization
    print('Error initializing Firebase notifications: $e');
  }

  // Start the Flutter app
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Fonts',
      // Set Raleway as the default app font.
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFd0dacc), ),
          useMaterial3: true,
          fontFamily: 'Poppins'),
      navigatorKey: navigatorKey,
      initialRoute: "/login",
      routes: {
        "/signUp": (context) => const SignUpPage(),
        "/login": (context) => const LoginPage(),
        "/home": (context) => const LandingPage(),
        "/Question1": (context) => QuestionOne(),
      },
    );
  }
}
