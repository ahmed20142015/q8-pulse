import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/Controllers/UserController.dart';
import 'package:q8_pulse/Screens/bubbles.dart';
import 'package:q8_pulse/Screens/gust_screen.dart';

import 'package:q8_pulse/Screens/register_screen.dart';

import 'package:q8_pulse/utils/app_Localization.dart';

class Onboarding3Screen extends StatefulWidget {
  createState() => Onboarding3view();
}

class Onboarding3view extends StateMVC<Onboarding3Screen> {
  Onboarding3view() : super(UserController()) {
    _userController = UserController.con;
  }
  UserController _userController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xff2B2B2B),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.width / 0.7,
                        width: MediaQuery.of(context).size.width / 0.5,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/imgs/Il_Onboarding3_dark@3x.png"),
                                )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 100,
                            child: Text(
                                 DemoLocalizations.of(context).title['_onboarding3'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width/23,
                                ))),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            child: Text(
                              DemoLocalizations.of(context).title['_skip'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width/23,
                                )),
                          ),
                          onTap: () {
                               Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => GustScreen()),
  (Route<dynamic> route) => false,
);
                          },
                        ),
                        Container(
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffFFE33F),
                                ),
                              ),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffFFE33F),
                                ),
                              ),
                              Container(
                                height: 8,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Color(0xffFFE33F),
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          child: Container(
                            child: Text(
                              DemoLocalizations.of(context).title['_next'],
                                style: TextStyle(
                                  color: Color(0xffFFE33F),
                                  fontSize: MediaQuery.of(context).size.width/23,
                                )),
                          ),
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => GustScreen()),
  (Route<dynamic> route) => false,
);
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
