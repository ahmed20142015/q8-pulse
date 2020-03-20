import 'package:flutter/material.dart';
import 'package:q8_pulse/Controllers/HomeController.dart';
import 'package:q8_pulse/Data/Models/ScopeModelWrapper.dart';
import 'package:q8_pulse/Screens/register_screen.dart';
import 'package:q8_pulse/utils/app_Localization.dart';
import 'package:scoped_model/scoped_model.dart';

class SharedWidget {

 static bool is_loading = false ;
  static loading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void showSnackBar(GlobalKey<ScaffoldState> key, message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    key.currentState.showSnackBar(snackBar);
  }
   static   Widget arrowBack() {
      return ScopedModelDescendant<AppModel>(
        builder: (context,child,model){
          return InkWell(
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage( 
                      model.appLocale == Locale('en')
                  ? "assets/imgs/Chevron.png"
                  : "assets/imgs/chevron2.png"
                  ))),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        );
        },
             
      );
    }

static Widget shareWidget(BuildContext context , bool valueMode) {
   return InkWell(
     child: Container(
       width: 30,
       height: 30,
       decoration: BoxDecoration(
           image: DecorationImage(
               image: AssetImage(valueMode == true
                   ? "assets/imgs/sharelight.png"
                   : "assets/imgs/share.png"))),
     ),
     onTap: () {
       HomeController().share(context);
     },
   );
 }
 static Future<void> dialogLogin(BuildContext context) async {
   // check if 0 skill , 1 history , 2 education
   return showDialog<void>(
     context: context,
     barrierDismissible: false, // user must tap button!
     builder: (BuildContext context) {
       return AlertDialog(
         shape:
         RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
         content: SingleChildScrollView(
           child: ListBody(
             children: <Widget>[
               Text(
                 DemoLocalizations.of(context).title['_register_message'],
                 textAlign: TextAlign.center,
                 style: TextStyle(color: Colors.grey[800] , fontSize: MediaQuery.of(context).size.width/25),
               ),
             ],
           ),
         ),
         actions: <Widget>[
           new Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
               Padding(
                 padding: const EdgeInsets.only(top: 0.0),
                 child: InkWell(
                   child: new Container(
                     width: MediaQuery.of(context).size.width / 2.8,
                     child: new Material(
                         color: const Color(0xffF2C438),
                         elevation: 0.0,
                         shape: new RoundedRectangleBorder(
                             borderRadius: new BorderRadius.circular(30.0),
                             side:
                             BorderSide(color: Colors.white, width: 2.0)),
                         child: new Center(
                             child: new Padding(
                                 padding: new EdgeInsets.only(
                                     top: 8.0, bottom: 8.0),
                                 child: new Text(
                                   DemoLocalizations.of(context).title['_register_button'],
                                   style: new TextStyle(
                                       color: Colors.white, fontSize: MediaQuery.of(context).size.width/25),
                                 )))),
                   ),
                   onTap: () {

                     Navigator.pushAndRemoveUntil(context,new MaterialPageRoute(
                         builder: (BuildContext context) => RegisterScreen()),
                           (Route<dynamic> route) => false,);


                   },
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.only(top: 0.0),
                 child: InkWell(
                   child: new Container(
                     width: MediaQuery.of(context).size.width / 2.8,
                     child: new Material(
                         color: const Color(0xffF2C438),
                         elevation: 0.0,
                         shape: new RoundedRectangleBorder(
                             borderRadius: new BorderRadius.circular(30.0),
                             side:
                             BorderSide(color: Colors.white, width: 2.0)),
                         child: new Center(
                             child: new Padding(
                                 padding: new EdgeInsets.only(
                                     top: 8.0, bottom: 8.0),
                                 child: new Text(
                                   DemoLocalizations.of(context).title['_cancel_button'],
                                   style: new TextStyle(
                                       color: Colors.white, fontSize: MediaQuery.of(context).size.width/25),
                                 )))),
                   ),
                   onTap: () {
                     Navigator.of(context).pop();
                   },
                 ),
               ),
             ],
           ),
         ],
       );
     },
   );
 }
 static Future<void> dialogRecord(BuildContext context) async {
   // check if 0 skill , 1 history , 2 education
   return showDialog<void>(
     context: context,
     barrierDismissible: false, // user must tap button!
     builder: (BuildContext context) {
       return AlertDialog(
         shape:
         RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
         content: SingleChildScrollView(
           child: ListBody(
             children: <Widget>[
               Text(
                 DemoLocalizations.of(context).title['_record_message'],
                 textAlign: TextAlign.center,
                 style: TextStyle(color: Colors.grey[800] , fontSize: MediaQuery.of(context).size.width/25),
               ),
             ],
           ),
         ),
         actions: <Widget>[
           new Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[

               Padding(
                 padding: const EdgeInsets.only(top: 0.0),
                 child: InkWell(
                   child: new Container(
                     width: MediaQuery.of(context).size.width / 2.8,
                     child: new Material(
                         color: const Color(0xffF2C438),
                         elevation: 0.0,
                         shape: new RoundedRectangleBorder(
                             borderRadius: new BorderRadius.circular(30.0),
                             side:
                             BorderSide(color: Colors.white, width: 2.0)),
                         child: new Center(
                             child: new Padding(
                                 padding: new EdgeInsets.only(
                                     top: 8.0, bottom: 8.0),
                                 child: new Text(
                                   DemoLocalizations.of(context).title['_ok_button'],
                                   style: new TextStyle(
                                       color: Colors.white, fontSize: MediaQuery.of(context).size.width/25),
                                 )))),
                   ),
                   onTap: () {
                     Navigator.of(context).pop();
                   },
                 ),
               ),
             ],
           ),
         ],
       );
     },
   );
 }
  
}
