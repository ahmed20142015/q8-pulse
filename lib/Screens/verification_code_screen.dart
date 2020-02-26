import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/Controllers/UserController.dart';

import 'package:q8_pulse/Screens/create_password_screen.dart';
import 'package:q8_pulse/Screens/new_password_screen.dart';
import 'package:q8_pulse/Widgets/AppBarWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';

class VerificationCodeScreen extends StatefulWidget {
  String forgot_or_register;
  String verificationCode;
  String phone;
  VerificationCodeScreen(
      {this.verificationCode, this.phone, this.forgot_or_register});
  createState() => VerificationCodeView();
}

class VerificationCodeView extends StateMVC<VerificationCodeScreen> {
  VerificationCodeView() : super(UserController()) {
    _userController = UserController.con;
  }
  UserController _userController;
    Timer _timer;
  int counter = 30;
  void startTimer()  {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
        
             if (counter < 1) {
            timer.cancel();
          
          } else {
            counter = counter - 1;
          }
          
        },
      ),
    );
  }

  initState() {
    super.initState();
    startTimer();
    // print(widget.data['otp'].toString());
    // print(widget.data['phone'].toString());
  }

  Widget arrowBack() {
    return InkWell(
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/imgs/ic_back@3x.png"))),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget title() {
    return Text(
      DemoLocalizations.of(context).title['_verification'],
      style: TextStyle(fontSize: 18),
    );
  }

  Widget nullWedgit() {
    return Container(
      width: 25,
      height: 25,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:  AppBarWidget()
                .showAppBar(context, arrowBack(), title(), nullWedgit()),
      body: Column(
          children: <Widget>[
           

            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 50),
              child: Text(
                  "${DemoLocalizations.of(context).title['_enter_the_4-diglt_code_sent_to_you_at']} ${widget.phone}" , 
                  style: TextStyle(fontSize: 18),),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //     left: 32,
            //     right: 32,
            //   ),
            //   child: Text(
            //     "${DemoLocalizations.of(context).title["_didn't_enter_the_number_correctly"]} ?",
            //     style: TextStyle(color: Color(0xffFFDE47)),
            //   ),
            // ),

            Container(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: new VerificationCodeInput(
                    keyboardType: TextInputType.number,
                    textStyle: TextStyle(),
                    length: 4,
                    onCompleted: (String value) {
                      setState(() {
                        this.widget.verificationCode = value;
                        print(value);
                      });
                      if (value.toString() != widget.verificationCode.toString()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(DemoLocalizations.of(context)
                                  .title['_the_numper_is_not_crrect'],style: TextStyle(fontSize: 18),),
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(DemoLocalizations.of(context)
                                  .title['_the_member_is_confirmed'],style: TextStyle(fontSize: 18),),
                            );
                          },
                        );

                        widget.forgot_or_register == "forgot"
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewPasswordScreen(
                                    phone: widget.phone,
                                  ),
                                ),
                              )
                            : Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreatPasswordScreen(
                                          phone: widget.phone,
                                        )));
                      }
                    }),
              ),
            ),

            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  "${DemoLocalizations.of(context).title['_resend']}($counter)",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff9C9C9C),
                  ),
                ),
              ),
              onTap: () {
                // resendVerifcatoinCode();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: 
              counter == 0 ?
   InkWell(
                child: Container(
                  height: 45.0,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Material(
                    color: const Color(0xffFFE240),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                        child: Text(
                          DemoLocalizations.of(context).title['_verify'],
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                _userController.resendCodeVerification(widget.phone);
                },
              )
              :
              InkWell(
                child: Container(
                  height: 45.0,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Material(
                    color: const Color(0xffFFE240).withOpacity(0.5),
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                        child: Text(
                          DemoLocalizations.of(context).title['_verify'],
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                 
                },
              ),
            ),
            // showErrorMsg(),
          ],
        ),
     
    );
  }
}
