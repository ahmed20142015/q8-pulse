import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/UserController.dart';
import 'package:q8_pulse/Controllers/UserLocalStorage.dart';
import 'package:q8_pulse/Screens/about_screen.dart';
import 'package:q8_pulse/Screens/all_news_screen.dart';
import 'package:q8_pulse/Screens/all_presentrs_screen.dart';
import 'package:q8_pulse/Screens/galary_screen.dart';
import 'package:q8_pulse/Screens/profile_screen.dart';
import 'package:q8_pulse/Screens/schedule_screen.dart';
import 'package:q8_pulse/Screens/shows_screen.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:q8_pulse/utils/app_Localization.dart';

class DrawerW {
  UserController _userController = UserController();

  Widget showDrawer(
      BuildContext context,
      Widget switcher,
      Widget switcherLang,
      bool valueMode,
      String userImage,
      String firstName,
      String lastName,
      List<String> googleInfo,
      GlobalKey<ScaffoldState> scaffoldKey,
      int userId) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      

      decoration: BoxDecoration(),
      child: Drawer(
        child: SingleChildScrollView(
          child: Container(
height: MediaQuery.of(context).size.height/0.7,
            decoration: BoxDecoration(
                color: valueMode == true ? Color(0xff2B2B2B) : Colors.white),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xffF2C438),
                                  Color(0xffF29A2E)
                                ]),
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width / 10,
                                    backgroundImage: userId != 015
                                        ? NetworkImage(userId != null
                                            ? "${ConstantVarable.apiImg}$userImage"
                                            : "${googleInfo[1]}")
                                        : AssetImage(
                                            "assets/imgs/person_avatar.jpg")),
                                Text(
                                  userId != null
                                      ? "$firstName $lastName"
                                      : "${googleInfo[0].toString()}",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/imgs/ic_more@3x.png"))),
                                  ),
                                  onTap: () {
                                    UserLocalStorage().getUser().then((user) {
                                      if (user.phone != null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen()));
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          onTap: () {

                            if(userId!=015) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        socialData: googleInfo,
                                      )));
                            }else{

                              SharedWidget.dialogLogin(context);

                            }





                          },
                        ),
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2.4,
                            decoration: BoxDecoration(
                                color: Color(0xffF2C438).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(22)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 8,
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/imgs/_ionicons_svg_ios-play.png"))),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16, right: 8),
                                  child: Text(
                                    DemoLocalizations.of(context)
                                        .title['_live_stream'],
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25,
                                        color: valueMode == true
                                            ? Colors.grey[400]
                                            : Color(0xff585757),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(valueMode == true
                                            ? "assets/imgs/ic_microphone_dark@3x.png"
                                            : "assets/imgs/microphone.png"))),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Text(
                                  DemoLocalizations.of(context).title['_shows'],
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      color: valueMode == true
                                          ? Colors.grey[400]
                                          : Color(0xff585757),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowsScreen(
                                      valueMode: valueMode, guestId: userId)));
                        },
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(valueMode == true
                                            ? "assets/imgs/ic_presenter_dark@3x.png"
                                            : "assets/imgs/customer-service.png"))),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Text(
                                  DemoLocalizations.of(context)
                                      .title['_presenters'],
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      color: valueMode == true
                                          ? Colors.grey[400]
                                          : Color(0xff585757),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllPresentersScreen(
                                        valueMode: valueMode,
                                        guestId: userId,
                                      )));
                        },
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(valueMode == true
                                            ? "assets/imgs/ic_news_dark@3x.png"
                                            : "assets/imgs/newspaper-folded.png"))),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Text(
                                  DemoLocalizations.of(context)
                                      .title['_schedule'],
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      color: valueMode == true
                                          ? Colors.grey[400]
                                          : Color(0xff585757),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScheduleScreen(
                                        valueMode: valueMode,
                                      )));
                        },
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(valueMode == true
                                            ? "assets/imgs/insert-picture-icon.png"
                                            : "assets/imgs/gallery.png"))),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Text(
                                  DemoLocalizations.of(context)
                                      .title['_gallary'],
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      color: valueMode == true
                                          ? Colors.grey[400]
                                          : Color(0xff585757),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GalaryScreen(
                                        valueMode: valueMode,
                                      )));
                        },
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(valueMode == false
                                            ? "assets/imgs/ic_news@3x.png"
                                            : "assets/imgs/ic_news_dark@3x.png"))),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Text(
                                  DemoLocalizations.of(context).title['_news'],
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      color: valueMode == true
                                          ? Colors.grey[400]
                                          : Color(0xff585757),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 45,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllNewsScreen(
                                        valueMode: valueMode,
                                      )));
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Divider(
                    color: Colors.grey[500],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Text(
                                DemoLocalizations.of(context).title['_about'],
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: Color(0xffF2C438),
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AboutScreen()));
                              },
                            ),
                            Text(
                              "${DemoLocalizations.of(context).title['_version']} 2.1",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25,
                                  color: valueMode == true
                                      ? Colors.grey[400]
                                      : Color(0xff585757),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              DemoLocalizations.of(context)
                                  .title['_contact_us'],
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25,
                                  color: valueMode == true
                                      ? Colors.grey[400]
                                      : Color(0xff585757),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              DemoLocalizations.of(context)
                                  .title['_night_mode'],
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25,
                                  color: valueMode == true
                                      ? Colors.grey[400]
                                      : Color(0xff585757),
                                  fontWeight: FontWeight.bold),
                            ),
                            switcher,
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              DemoLocalizations.of(context).title['_language'],
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25,
                                  color: valueMode == true
                                      ? Colors.grey[400]
                                      : Color(0xff585757),
                                  fontWeight: FontWeight.bold),
                            ),
//                             CircleAvatar(
// radius: 20,
// backgroundColor: Color(0xffF2C438),
// child: Text(_valueLang==true ? " EN " : " AR "),
//                             ),
                            switcherLang
                          ],
                        ),
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                DemoLocalizations.of(context).title['_log_out'],
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 25,
                                    color: valueMode == true
                                        ? Colors.grey[400]
                                        : Color(0xff585757),
                                    fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                "assets/imgs/logout.png",
                                width: 40,
                                height: 40,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          _userController.googleSignOut(context);
                          UserLocalStorage().clear();
                          _userController.facebookLogout(context);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

        // ICONS
      ),
    );
  }
}
