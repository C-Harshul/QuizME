import 'package:flutter/material.dart';
import 'package:quizme/RoundedButton.dart';
class Hub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          RoundedButton(
            title: 'Login',
            colour: Colors.white,
            onPressed: (){
              Navigator.popAndPushNamed(context, '/login');
            },
          ),
          RoundedButton(
            title: 'Register',
            colour: Colors.white,
            onPressed: (){
              Navigator.popAndPushNamed(context, '/Reg');
            },
          )
        ],
      ),
    );
  }
}
