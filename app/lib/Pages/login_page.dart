
import 'package:app/Pages/Questionnaire/question_1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class loginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _loginPageState();
  }

}

class _loginPageState extends State<loginPage>{
  GlobalKey<FormState> _loginFormKey = GlobalKey();

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

      Widget _loginForm(){
        return SizedBox(
          width: MediaQuery.sizeOf(context).width * .90,
          height: MediaQuery.sizeOf(context).height * .30,
          child: Form(
            key: _loginFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Username",
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                ),
                _loginButton(),
              ],
            ),
          ),
        );
      }

      Widget _loginButton(){
        return SizedBox(
          width: MediaQuery.sizeOf(context).width * .60,
          child: ElevatedButton(
            onPressed: (){
              // Add authentication here
              //for now: skip that part and just go to questionnaire
              Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => QuestionOne()));
            },
            child: const Text(
              "Login",
              ),
          ),
        );
      }

}