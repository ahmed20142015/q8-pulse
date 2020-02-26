import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/UserController.dart';
import 'package:q8_pulse/Controllers/UserLocalStorage.dart';
import 'package:q8_pulse/Widgets/AppBarWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';



class ProfileScreen extends StatefulWidget {
  List<String> socialData ;
  ProfileScreen({this.socialData});

  createState() => ProfileView();
}

class ProfileView extends StateMVC<ProfileScreen> {
  ProfileView() : super(UserController()) {
    _userController = UserController.con;
  }

  UserController _userController;
  initState(){
    super.initState();

    UserLocalStorage().getUser().then((user){

     if(user.first_name==null){
       ConstantVarable.firstNameController.text = widget.socialData[0];
       ConstantVarable.lastNameController.text = widget.socialData[0];
     }else{
       ConstantVarable.firstNameController.text = user.first_name;
       ConstantVarable.lastNameController.text = user.last_name;
     }
    });
      

  }

  Widget nullWedgit() {
    return Container(
      width: 30,
      height: 30,
    );
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
                  child: Column(
            
            children: <Widget>[
              AppBarWidget()
                  .showAppBar(context, arrowBack(), nullWedgit(), nullWedgit()),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/1.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            DemoLocalizations.of(context).title['_complet_your_profile'],
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/25,
                            ),
                          )
                        ],
                      ),
                      imageProfile(),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(22)),
                        height: MediaQuery.of(context).size.width/20,
                        width: MediaQuery.of(context).size.width/2,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: ConstantVarable.firstNameController,
                                  validator: (val) =>
                                      _userController.validateUserName(val),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        right: 16.0, top: 0.0, left: 16),
                                    hintText:  DemoLocalizations.of(context).title['_first_name'],
                                    hintStyle: TextStyle(
                                        color: Colors.grey[400], fontSize: MediaQuery.of(context).size.width/25,),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.circular(22)),
                        height: MediaQuery.of(context).size.width/20,
                        width: MediaQuery.of(context).size.width/2,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: ConstantVarable.lastNameController,
                                  validator: (val) =>
                                      _userController.validateUserName(val),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        right: 16.0, top: 0.0, left: 16),
                                    hintText: DemoLocalizations.of(context).title['_last_name'],
                                    hintStyle: TextStyle(
                                        color: Colors.grey[400], fontSize: MediaQuery.of(context).size.width/25,),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ConstantVarable.firstNameController.text == null ?
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(27),
                              gradient: LinearGradient(
                                  colors: [Color(0xffF2C438), Color(0xffF29A2E)]),
                            ),
                            height: MediaQuery.of(context).size.width/20,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Padding(
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                 
                                
                                  Text(
                                    DemoLocalizations.of(context).title['_add_data'],
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: MediaQuery.of(context).size.width/25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {

                           
    UserLocalStorage().getUser().then((user){

   _userController.updateProfileLogic(
       user.phone,
   ConstantVarable.firstNameController.text,
    ConstantVarable.lastNameController.text,
     _userController.imageProfile,context);


});
                           
                          },
                        ),
                      ):
                       Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(27),
                              gradient: LinearGradient(
                                  colors: [Color(0xffF2C438), Color(0xffF29A2E)]),
                            ),
                            height: MediaQuery.of(context).size.height/20,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Padding(
                              padding: EdgeInsets.only(top:4.0, bottom: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                 
                                
                                  Text(
                                    DemoLocalizations.of(context).title['_update'],
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: MediaQuery.of(context).size.width/25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {

                           
    UserLocalStorage().getUser().then((user){

   _userController.updateProfileLogic(user.phone,
   ConstantVarable.firstNameController.text,
    ConstantVarable.lastNameController.text,
     _userController.imageProfile ,context);


});
                           
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xffBF1162),
            radius: MediaQuery.of(context).size.width/15,
            child: _userController.imageProfile == null
                ? CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/imgs/person_avatar.jpg"),
                    radius: MediaQuery.of(context).size.width/15,
                  )
                : _userController.imageProfile != null
                    ? CircleAvatar(
                        backgroundImage:
                            FileImage(_userController.imageProfile),
                        radius: 50,
                      )
                    : Card(
                        shape: CircleBorder(),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            child: Image.asset(
                              'assets/imgs/ic_upload_avatar.png',
                              height: 300,
                            ))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: RaisedButton(
            shape: CircleBorder(),
            child: Icon(Icons.add_a_photo),
            onPressed: () {
              _userController.getImageProfile();
            },
          ),
        )
      ],
    );
  }
}
