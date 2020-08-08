import 'package:chatapplication/helper/Helper%20Function.dart';
import 'package:chatapplication/services/auth.dart';
import 'package:chatapplication/views/chatrooms.dart';
import 'package:chatapplication/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:chatapplication/services/database.dart';

class SignUp extends StatefulWidget {

  final Function toggle;

  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  final formkey =GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethod = new DatabaseMethods();


  TextEditingController usernameTextEditingController =new TextEditingController();
  TextEditingController emailTextEditingController =new TextEditingController();
  TextEditingController passwordTextEditingController =new TextEditingController();

  signMeUp() {
    if (formkey.currentState.validate()) {
      Map<String, String> userInfoMap ={
        "name" : usernameTextEditingController.text,
        "email" : emailTextEditingController.text,
      };

     // these 2 are mentioned above because when it goes too loading screen these  values won't be available
      HelperFunction.saveUserNameSharedPreference(usernameTextEditingController.text);
      HelperFunction.saveUserEmailSharedPreference(emailTextEditingController.text);

      setState(() {
        isLoading = true ;
      });
        authMethods.SignupWithEmailPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        print("${val.uid}");

        databaseMethod.uploadUserInfo(userInfoMap);

        HelperFunction.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => ChatRoom(),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading?Container(
        child: Center(child: CircularProgressIndicator()),
      ):SingleChildScrollView(
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
                         return val.isEmpty || val.length<3 ? "Please provide user Name whose length is >3 words" : null;
                       },
                       controller: usernameTextEditingController,
                       style: style(),
                       decoration: textFieldInputDecoration("UserName"),
                     ),
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
                         return val.length >6 ? null : "Please Provide password 6+ character";
                       },
                       controller: passwordTextEditingController,
                       style: style(),
                       decoration:textFieldInputDecoration("Password"),
                     ),
                   ],
                 ),
               ),
                SizedBox(height: 10,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                    child: Text("Forgot Password?", style: style(),),
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    //TODO
                    signMeUp();
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
                    child: Text("Sign Up",style: TextStyle(color: Colors.white, fontSize: 17) ,),
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
                  child: Text("Sign Up with Google",style: TextStyle(color: Colors.black54, fontSize: 17) ,),
                ),
                SizedBox( height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?",style: TextStyle(
                        fontSize: 12,
                        color: Colors.white
                    ),),
                    SizedBox( width: 6,),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Text("SignIn Now",style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
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
