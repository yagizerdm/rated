import 'package:flutter/cupertino.dart';
import 'package:rated/screens/auth_screens/login_screen.dart';
import '../screens/auth_screens/register_screen.dart';

class AuthScreenControl extends StatefulWidget {
  const AuthScreenControl({Key? key}) : super(key: key);

  @override
  State<AuthScreenControl> createState() => _AuthScreenControlState();
}

class _AuthScreenControlState extends State<AuthScreenControl> {

  bool showLoginPage = true;

  void toggleScreens(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginScreen(showRegisterScreen: toggleScreens);
    } else{
      return RegisterScreen(showLoginScreen: toggleScreens);
    }
  }
}
