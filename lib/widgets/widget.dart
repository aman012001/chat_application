import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context)
{
return AppBar(
  title: Image.asset("assets/images/logo.png",height: 50,),
  centerTitle: true,
  backgroundColor: Colors.lightBlue,
);
}

InputDecoration textFieldInputDecoration(String hintText)
{
  return InputDecoration(
    hintText: hintText,
    fillColor: Colors.grey,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white)
    ),
  );
}

TextStyle style()
{
  return TextStyle(
    color: Colors.white,
    fontSize: 15,
  );
}