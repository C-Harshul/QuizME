import 'package:flutter/material.dart';
import 'package:quizme/screens/Q_Cards.dart';
import 'package:quizme/screens/Register.dart';
import 'package:quizme/screens/login.dart';
import 'package:quizme/screens/Hub.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF0A0E21),
        accentColor: Colors.purple,
      ),
      home:Register(),
      routes: {
        '/QCards':(context)=>QCards(),
        '/Reg':(context)=>Register(),
        '/login':(context)=>Login(),
        '/hub':(context)=>Register(),
      },
    );
  }
}


