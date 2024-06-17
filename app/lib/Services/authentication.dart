import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



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