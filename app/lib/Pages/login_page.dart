
import 'package:app/Pages/home_page.dart';
import 'package:app/Pages/sign_up.dart';
import 'package:app/Services/authentication.dart';
import 'package:app/Components/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Components/text_field.dart';

class loginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _loginPageState();
  }

}

class _loginPageState extends State<loginPage>{

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

void loginUser() async {
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the home screen
      Navigator.pushNamed(context, "/home");
    } else {
      setState(() {
        isLoading = false;
      });
      // show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email or password is incorrect.')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
         Text(
          "Login",
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
              _loginForm(),
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

      Widget _loginForm() {
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
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.text),
            TextFieldInput(
              icon: Icons.lock,
              textEditingController: passwordController,
              hintText: 'Enter your passord',
              textInputType: TextInputType.text,
              isPass: true,
            ),
                MyButtons(onTap: loginUser, text: "Log In"),
              ],
            ),
          ),
          _signUpOption(),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .60,
      child: ElevatedButton(
        onPressed: () {
           Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => homePage()));
        },
        child: const Text("Login"),
      ),
    );
  }

  Widget _signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        TextButton(
          onPressed: () {
             Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => signUpPage()));
          },
          child: const Text("Sign up"),
        ),
      ],
    );
  }
}