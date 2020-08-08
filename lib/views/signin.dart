import 'package:chatapplication/helper/Helper%20Function.dart';
import 'package:chatapplication/helper/authenticate.dart';
import 'package:chatapplication/services/auth.dart';
import 'package:chatapplication/services/database.dart';
import 'package:chatapplication/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatrooms.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formkey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController emailTextEditingController =new TextEditingController();
  TextEditingController passwordTextEditingController =new TextEditingController();

  bool isLoading= false;
  QuerySnapshot snapshotUserInfo;

  signIn(){
    if(formkey.currentState.validate())
      {
        //HelperFunction.saveUserNameSharedPreference(usernameTextEditingController.text);
        HelperFunction.saveUserEmailSharedPreference(emailTextEditingController.text);

          //TODO function to get user details
            databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val) {
            snapshotUserInfo = val;
            HelperFunction.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);

            setState(() {
              isLoading = true ;
            });

          });

          authMethods.SignInWithEmailPassword(emailTextEditingController.text , passwordTextEditingController .text).then((val){
            if(val!= null){
              HelperFunction.saveUserLoggedInSharedPreference(true);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => ChatRoom(),
              ));
            }
          });

      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-100,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$").hasMatch(val) ?null : "Please Provide Valid Email Id" ; },
                        controller: emailTextEditingController,
                        style: style(),
                        decoration: textFieldInputDecoration("Email"),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val.length >6 ? null : "Please Provide Suitable Password ";
                        },
                        controller: passwordTextEditingController,
                        style: style(),
                        decoration:textFieldInputDecoration("Password"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    authMethods.resetPass(emailTextEditingController.text);
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                    child: Text("Forgot Password?", style: style(),),
                  ),
                  ),
                ),
                SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      signIn();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC)
                          ]
                        )
                      ),
                      child: Text("Sign In",style: TextStyle(color: Colors.white, fontSize: 17) ,),
                    ),
                  ),
                SizedBox(height: 15,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Text("Sign In with Google",style: TextStyle(color: Colors.black54, fontSize: 17) ,),
                ),
                SizedBox( height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account?",style: TextStyle(
                        fontSize: 12,
                        color: Colors.white
                    ),),
                    SizedBox( width: 6,),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Register Now",style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
