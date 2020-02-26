import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData darkTheme = ThemeData(
  primaryColorDark: Colors.grey[800],
    fontFamily: "Tajawal",
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Color(0xff2B2B2B),
    cardColor: Colors.grey[800],


    primaryColor: Color(0xff1f655d),
    accentColor: Color(0xffE2E2E2),
    textTheme: TextTheme().copyWith(
      title: TextStyle(color: Color(0xffE2E2E2),fontSize: 18 ),
      subtitle: TextStyle(color: Colors.white,fontSize: 15 ),
      subhead: TextStyle(color: Colors.white,fontSize: 18 ),
      body1: TextStyle(color: Colors.white,fontSize: 18 ),
      body2: TextStyle(color: Colors.white, fontSize: 15),

    ),
    appBarTheme: AppBarTheme(color: Color(0xff1f655d)));

ThemeData lightTheme = ThemeData(
    primaryColorDark: Colors.grey[800],
    fontFamily: "Tajawal",
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    accentColor: Color(0xff40bf7a),
    textTheme: TextTheme().copyWith(
        title: TextStyle(color: Colors.grey, ),
        subtitle: TextStyle(color: Colors.black54, ),
        subhead: TextStyle(color: Colors.black54,),
      body1: TextStyle(color: Colors.grey[800], ),
      body2: TextStyle(color: Colors.grey[800], ),),

    appBarTheme: AppBarTheme(
        color: Color(0xff1f655d),
        actionsIconTheme: IconThemeData(color: Colors.black54)));
