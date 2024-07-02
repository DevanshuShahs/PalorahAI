import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthMethod {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;



  

  // SignUp User

  Future<String> signupUser({
    
    required String email,
    required String password,
    required String name,
    
  }) async {
    String res = "Some error Occurred";
    
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          name.isNotEmpty) {
          
          
          try {
  UserCredential cred = await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  print("User created: ${cred.user!.uid}");

  await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
        });
} catch (e) {
  print("Error: $e");
}
  
        res = "success";
        print(res);
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logIn user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // for sighout
  signOut() async {
    // await _auth.signOut();
  }
}

class UserPlanProvider with ChangeNotifier {
  bool _isLoading = true;
  bool _hasExistingPlan = false;
  String? _plan;

  bool get isLoading => _isLoading;
  bool get hasExistingPlan => _hasExistingPlan;
  String? get plan => _plan;

  UserPlanProvider() {
    _fetchUserPlan();
  }

  Future<void> _fetchUserPlan() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      User? user = auth.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await firestore
            .collection('plans')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          _plan = querySnapshot.docs.first['plan'];
          _hasExistingPlan = true;
        }
      }
    } catch (e) {
      print('Error fetching plan: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}