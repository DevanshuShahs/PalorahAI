import 'package:app/Components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgotPasswordPage extends StatefulWidget {
  const forgotPasswordPage({super.key});

  @override
  State<forgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<forgotPasswordPage> {

  final emailController = TextEditingController();


  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }



  Future passwordReset() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
       showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text('Password Email Reset Link Sent! Please Check Your Email'),
        );
      });
    }
    on FirebaseAuthException catch (e){
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Theme.of(context).primaryColor;
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text('Enter Your Email and We will Send You a Password Reset Link',
            textAlign: TextAlign.center,
            
            ),
          ),
          SizedBox(height: 16,),
          TextFieldInput(
                                icon: Icons.email,
                                textEditingController: emailController,
                                hintText: 'Enter your email',
                                textInputType: TextInputType.emailAddress,
                                fillColor: primaryGreen.withOpacity(0.1),
                                iconColor: primaryGreen,
                              ),

          MaterialButton(onPressed: passwordReset,
          child: Text('Reset Password'),
          color: primaryGreen,
          )
        ],
      )
    );
  }
}