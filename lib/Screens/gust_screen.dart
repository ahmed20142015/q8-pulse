import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/UserController.dart';
import 'package:q8_pulse/Screens/bubbles.dart';
import 'package:q8_pulse/Screens/login_screen.dart';
import 'package:q8_pulse/Screens/register_screen.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';

class GustScreen extends StatefulWidget {
  createState() => GustView();
}

class GustView extends StateMVC<GustScreen> {
  GustView() : super(UserController()) {
    _userController = UserController.con;
  }

  UserController _userController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child:

                InkWell(
                  child: Container(
                    height: 30,
                    child: Text(
                      DemoLocalizations.of(context)
                          .title['_containue'],
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/25,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  onTap: () {

                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => BubblesScreen(
                          userId: 015,
                          phone: "012210732092020",
                          firstName: "Guest",
                          lastName: "User",
                          userImage: "uploads/customers/user_profile/Avatar.png",


                        )));
                  },
                )

            ),
          ],
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                  ),
                  child: Column(
                      children: <Widget>[
                        
                        Image.asset("assets/imgs/88.8-Final-logo.png",width: 200,height: 200,),
                        InkWell(
                          child: Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width,
                            child: Material(
                              color: const Color(0xffFFE240),
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 4.0, bottom: 0.0),
                                  child: Text(
                                    DemoLocalizations.of(context)
                                        .title['_create_account'],
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: MediaQuery.of(context).size.width/25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Text(
                            "${DemoLocalizations.of(context).title['_already_registred']}",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width/25,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: InkWell(
                            child: Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width,
                              child: Material(
                                color: const Color(0xffFFE240),
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 4.0, bottom: 0.0),
                                    child: Text(
                                      DemoLocalizations.of(context)
                                          .title['_login'],
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: MediaQuery.of(context).size.width/25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {

                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            },
                          ),
                        ),

                      ],
                    ),
                 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
