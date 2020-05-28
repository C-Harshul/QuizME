import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizme/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;

  String password;

  String username;

  int i=0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                  'QuizME',
                  style:TextStyle(
                    fontFamily: 'Marker',
                    fontSize: 80,
                    color: Color(0xFFEB1555),
                  )
              ),
            ),
          SizedBox(
            child: Center(
            child: ScaleAnimatedTextKit(
              text: [
                'Research',
                'Learn',
                'Quiz'
              ],
              alignment: AlignmentDirectional.topStart,
              textStyle: TextStyle(
                fontFamily: 'Anton',
                fontSize: 80,
                color: Colors.white,
              ),
            )
          ),
        ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,50,20,0),
              child: FlatButton(
                color: Color(0xFFEB1555),
                child: Text(
                    'login',
                    style: TextStyle(
                      fontFamily: 'Marker',
                      fontSize: 30,
                      color: Color(0xFF1D1E33),
                    )
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                  List temp = ['all'];
                  final snapshot = await Firestore.instance.collection('QuizME').getDocuments();
                  for(var card in snapshot.documents){
                    final ID = card.documentID;
                    await Firestore.instance.collection('QuizME').document('$ID').updateData({'$username':temp});
                  }
                  Navigator.popAndPushNamed(context, '/QCards');
                },
              ),
            )
          ],
        )
    );
  }
}

