import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/UserController.dart';
import 'package:q8_pulse/Screens/forgot_password_screen.dart';
import 'package:q8_pulse/Screens/register_screen.dart';

import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';

class LoginScreen extends StatefulWidget {
  createState() => LoginView();
}

class LoginView extends StateMVC<LoginScreen> {
  LoginView() : super(UserController()) {
    _userController = UserController.con;
  }

  UserController _userController;
  bool is_loading = false;
  bool is_loadingFace = false;
  bool is_loadingGoogle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: <Widget>[
                      Text("Log in",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/23,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                  ),
                  child: Form(
                    key: ConstantVarable.loginformKey,
                    autovalidate: ConstantVarable.loginAutoValid,
                    child: Column(
                      children: <Widget>[
                        is_loadingFace
                            ? SharedWidget.loading(context)
                            : Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: InkWell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height/20,
                                    width: MediaQuery.of(context).size.width,
                                    child: Material(
                                      color: const Color(0xff3A559F),
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/imgs/faceLogo.png",
                                                   width: MediaQuery.of(context).size.width/17,
                                      height: MediaQuery.of(context).size.height/17,
                                            ),
                                            Container(
                                              width: 5,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 16),
                                              child: Text(
                                                "LOG IN WITH FACEBOOK",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: MediaQuery.of(context).size.width/25,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      is_loadingFace = true;
                                    });
                                    _userController.faceLogin(context);
                                    Timer(Duration(seconds: 2), () {
                                      setState(() {
                                        is_loadingFace = false;
                                      });
                                    });
                                  },
                                ),
                              ),
                        is_loadingGoogle
                            ? SharedWidget.loading(context)
                            : Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.grey[500]),
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                    height: MediaQuery.of(context).size.height/20,
                                    width: MediaQuery.of(context).size.width,
                                    child: Material(
                                      color: Colors.white,
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Image.asset(
                                                "assets/imgs/google_icone.png",
                                                width: 40,
                                              ),
                                              Container(
                                                width: 5,
                                              ),
                                              Text(
                                                "LOG IN WITH GOOGLE",
                                                style: TextStyle(
                                                    color: Colors.grey[800],
                                                    fontSize: MediaQuery.of(context).size.width/25,
                                                    fontFamily: 'JF Flat'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      is_loadingGoogle = true;
                                    });
                                    _userController.googleSignin(context);
                                    Timer(Duration(seconds: 2), () {
                                      setState(() {
                                        is_loadingGoogle = false;
                                      });
                                    });
                                  },
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Text(
                            "Or",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize:MediaQuery.of(context).size.width/23,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius: BorderRadius.circular(22)),
                          height: MediaQuery.of(context).size.height/20,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: ConstantVarable.phoneControllerLog,
                                    validator: (val) =>
                                        _userController.validatePhone(val),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          right: 16.0, top: 0.0, left: 16),
                                      hintText: "your phone numper",
                                      hintStyle: TextStyle(
                                          color: Color(0xffE2E2E2),
                                          fontSize: MediaQuery.of(context).size.width/25,),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 16,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius: BorderRadius.circular(22)),
                          height: MediaQuery.of(context).size.height/20,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    controller:
                                        ConstantVarable.passwordController,
                                    obscureText: true,
                                    validator: (val) =>
                                        _userController.validatePassword(val),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          right: 16.0, top: 0.0, left: 16),
                                      hintText: "your password",
                                      hintStyle: TextStyle(
                                          color: Color(0xffE2E2E2),
                                          fontSize: MediaQuery.of(context).size.width/25,),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  height: 40,
                                  child: Text(
                                    "Forgot Password",
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width/25,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPasswordScreen()));
                                },
                              ),
                            ],
                          ),
                        ),
                        _userController.showErrorMsg(),
                        is_loading
                            ? SharedWidget.loading(context)
                            : Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: InkWell(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height/20,
                                    width: MediaQuery.of(context).size.width,
                                    child: Material(
                                      color: const Color(0xffFFE240),
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 0.0, bottom: 0.0),
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
                                    setState(() {
                                      is_loading = true;
                                    });

                                    _userController.logIn(
                                        context,
                                        ConstantVarable.phoneControllerLog.text,
                                        ConstantVarable
                                            .passwordController.text);
                                    Timer(Duration(seconds: 2), () {
                                      setState(() {
                                        is_loading = false;
                                      });
                                    });
                                  },
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 90.0, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${DemoLocalizations.of(context).title['_not_registred']}",
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width/25,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                child: Container(
                                  height: 30,
                                  child: Text(
                                    DemoLocalizations.of(context)
                                        .title['_create_account'],
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width/25,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterScreen()));
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
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
