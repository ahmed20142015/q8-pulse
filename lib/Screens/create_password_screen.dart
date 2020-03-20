import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/UserController.dart';

import 'package:q8_pulse/utils/app_Localization.dart';

class CreatPasswordScreen extends StatefulWidget{
  String phone;
  CreatPasswordScreen({this.phone});
createState() => CreatePasswordView();
}

class CreatePasswordView extends StateMVC<CreatPasswordScreen>{

  CreatePasswordView() : super(UserController()){
_userController = UserController.con;

  }
  UserController _userController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16 ,top: 50),
                    child: Row(
                      children: <Widget>[
                        Text(
                          DemoLocalizations.of(context).title['_creat_password'],
                            style: TextStyle(
                              fontSize: 18,
                                color: Colors.grey[500],
                              fontWeight: FontWeight.w500
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
                      key: ConstantVarable.regformKey,
                      
                                          child: Column(
                        children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.only(top: 50 , bottom: 25),
                            child: Image.asset("assets/imgs/Il_authentication_dark@3x.png",
                            width: MediaQuery.of(context).size.width/1.5,
                            height: MediaQuery.of(context).size.height/2.5,),
                          ),

                             Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius: BorderRadius.circular(22)),
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.visiblePassword,
                                      controller: ConstantVarable.passwordController,
                                      obscureText: true,
                                      validator: (val) =>
                                          _userController.validatePassword(val),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,

                                        contentPadding: EdgeInsets.only(
                                            right: 16.0, top: 0.0, left: 16),
                                        hintText:DemoLocalizations.of(context).title['_your_password'],
                                        hintStyle: TextStyle(
                                            color: Color(0xffE2E2E2), fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(height: 16,),
                          
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius: BorderRadius.circular(22)),
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: TextFormField(
                                      keyboardType: TextInputType.visiblePassword,
                                      obscureText: true,
                                      controller: ConstantVarable.confirmPasswordController,
                                      validator: (val) =>
                                          _userController.validateConfirmPassword(val),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            right: 16.0, top: 0.0, left: 16),
                                        hintText: DemoLocalizations.of(context).title['_confirm_password'],
                                        hintStyle: TextStyle(
                                            color: Color(0xffE2E2E2), fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
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
                                      padding:
                                          EdgeInsets.only(top: 0.0, bottom: 0.0),
                                      child: Text(
                                       DemoLocalizations.of(context).title['_save_password'],
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                               _userController.register(
                                 context,widget.phone,
                                ConstantVarable.passwordController.text);
                               
                              },
                            ),
                          ),
                      
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

}