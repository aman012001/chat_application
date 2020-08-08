import 'package:chatapplication/views/signin.dart';
import 'package:chatapplication/views/signup.dart';
import 'package:flutter/material.dart';



class Authenticate extends StatefulWidget {

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

  class _AuthenticateState extends State<Authenticate> {

  bool showsignin = true;

  void toggleView(){
    setState(() {
      showsignin = !showsignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showsignin)
    {return SignIn(toggleView);}
    else{
      return SignUp(toggleView);
    }
  }
}
