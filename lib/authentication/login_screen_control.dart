import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rated/authentication/auth_screen_control.dart';
import 'package:rated/main.dart';

class LoginScreenControl extends StatelessWidget {
  const LoginScreenControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return MyApp();
          } else{
            return const AuthScreenControl();
          }
        },
      ),
    );
  }
}
