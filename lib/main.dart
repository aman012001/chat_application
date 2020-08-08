import 'package:chatapplication/helper/Helper%20Function.dart';
import 'package:chatapplication/helper/authenticate.dart';
import 'package:chatapplication/services/database.dart';
import 'package:chatapplication/views/chatrooms.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>  {

  bool userIsLoggedIn= false;


  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await HelperFunction.getUserLoggedInSharedPreference().then((val){
      setState(() {
        userIsLoggedIn= val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue[120],
      ),
      home: (userIsLoggedIn)? ChatRoom() :Authenticate(),
    );
  }
}

