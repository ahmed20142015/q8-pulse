import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/UserController.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';

class SocialDataScreen extends StatefulWidget {
  String phone;
  List<String> googleInfo;
  List<String> facebookInfo;

  SocialDataScreen({this.phone, this.googleInfo, this.facebookInfo});
  createState() => SocialDataView();
}

class SocialDataView extends StateMVC<SocialDataScreen> {
  SocialDataView() : super(UserController()) {
    _userController = UserController.con;
  }

  UserController _userController;
  bool isLoading = false;

  @override
  void dispose() {
    SocialDataView();
    // ConstantVarable.registerPhoneScaffoldkey.currentState.dispose();
    super.dispose();
    

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ConstantVarable.socialScaffoldkey,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16 ,top: 50),
                  child: Row(
                    children: <Widget>[
                      Text(
                          DemoLocalizations.of(context)
                              .title['_create_account'],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 32,
                    right: 32,
                  ),
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: ConstantVarable.socialFormKey,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius: BorderRadius.circular(22)),
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: ConstantVarable.phoneControllerReg,
                                    validator: (val) =>
                                        _userController.validatePhone(val),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          right: 16.0, top: 0.0, left: 16),
                                      hintText: DemoLocalizations.of(context)
                                          .title['_your_phone_numper'],
                                      hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _userController.showErrorMsg(),
                      ),
                      isLoading
                          ? SharedWidget.loading(context)
                          : Padding(
                              padding: const EdgeInsets.only(top: 16),
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
                                        padding: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0),
                                        child: Text(
                                          DemoLocalizations.of(context)
                                              .title['_create_account'],
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  _userController.socialDataLogic(context,
                                      ConstantVarable.phoneControllerReg.text,
                                      widget.googleInfo[0],
                                      widget.googleInfo[1],
                                      widget.googleInfo[2]);

                                  Timer(Duration(seconds: 2), () {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
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
}
