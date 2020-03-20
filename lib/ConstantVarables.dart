import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConstantVarable {
  static String apiUrl = "https://www.q8pulse.app/public/app/";
  static String apiImg = "https://www.q8pulse.app/public/";
  static String token;
 String constantPhone ;
  static String constantLang = "en" ;
  static String videoUrl ;



  static final GlobalKey<FormState> regformKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> regScaffoldkey = GlobalKey<ScaffoldState>();

  static bool regAutoValid = false;

  static final GlobalKey<FormState> regProformKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> regProScaffoldkey = GlobalKey<ScaffoldState>();

  static bool regProAutoValid = false;

  static final GlobalKey<FormState> loginformKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> loginScaffoldkey =
      GlobalKey<ScaffoldState>();
  static bool loginAutoValid = false;

  static final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> updateScaffoldkey =
      GlobalKey<ScaffoldState>();
  static bool updateAutoValid = false;

  static final GlobalKey<FormState> registerPhoneFormKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> registerPhoneScaffoldkey =
      GlobalKey<ScaffoldState>();
  static bool registerPhoneAutoValid = false;

    static final GlobalKey<FormState> socialFormKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> socialScaffoldkey =
      GlobalKey<ScaffoldState>();
  static bool socialAutoValid = false;

  static final TextEditingController phoneControllerReg = TextEditingController();
  static final TextEditingController phoneControllerLog = TextEditingController();

  static final TextEditingController passwordController =
      TextEditingController();

  static final TextEditingController confirmPasswordController =
      TextEditingController();

  static final TextEditingController firstNameController =
      TextEditingController();

  static final TextEditingController lastNameController =
      TextEditingController();

}
