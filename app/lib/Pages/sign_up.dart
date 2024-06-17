
import 'package:app/Pages/home_page.dart';
import 'package:app/Services/authentication.dart';
import 'package:app/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../text_field.dart';
class signUpPage extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() {
    return _signUpState();
  }

}

class _signUpState extends State<signUpPage>{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signupUser() async {

     String email = emailController.text;
    String password = passwordController.text;

    if (!email.endsWith('@gmail.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email must be a Gmail address.')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters long.')),
      );
      return;
    }
    // set is loading to true.
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthMethod().signupUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text);
    // if string return is success, user has been creaded and navigate to next screen other witse show error.
    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the next screen
       Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const homePage()));
    } else {
      setState(() {
        isLoading = false;
      });
    
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
         const Text(
          "Sign Up",
          ),
         ),
         body: SafeArea(
          child: _buildUI(),
          ),
       );
      }


      Widget _buildUI(){
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _title(),
              _signUpForm(),
            ],
          ),
        );
      }

      Widget _title(){
        return const Text(
          "PalorahAI",
          style: TextStyle(
            fontSize:35,
            fontWeight: FontWeight.w200,
          ),
          );
      }

      Widget _signUpForm() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .90,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFieldInput(
                icon: Icons.person,
                textEditingController: nameController,
                hintText: 'Enter your name',
                textInputType: TextInputType.text),
            TextFieldInput(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.text),
            TextFieldInput(
              icon: Icons.lock,
              textEditingController: passwordController,
              hintText: 'Enter your password',
              textInputType: TextInputType.text,
              isPass: true,
            ),
                MyButtons(
                onTap: signupUser,
                text: "Sign Up"
                 )

              ],
            ),
          ),
          _logInOption(),
        ],
      ),
    );
  }

  Widget _signUpButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .60,
      child: ElevatedButton(
        onPressed: () {
          signupUser();
        },
        child: const Text("Sign up"),
      ),
    );
  }

  Widget _logInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, "/login");
          },
          child: const Text("Log in"),
        ),
      ],
    );
  }
}