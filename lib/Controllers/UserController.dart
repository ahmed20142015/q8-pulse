import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:q8_pulse/Controllers/UserLocalStorage.dart';
import 'package:q8_pulse/Data/Models/ScopeModelWrapper.dart';
import 'package:q8_pulse/Data/Models/ServerResponseRegister.dart';
import 'package:q8_pulse/Data/Models/UserModel.dart';
import 'package:q8_pulse/Screens/bubbles.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:q8_pulse/Screens/gust_screen.dart';
import 'package:q8_pulse/Screens/register_screen.dart';
import 'package:q8_pulse/Screens/social_data_screen.dart';
import 'package:q8_pulse/Screens/verification_code_screen.dart';

class UserController extends ControllerMVC {
  //to make single instance of class
  factory UserController() {
    if (_this == null) _this = UserController._();
    return _this;
  }
  static UserController _this;

  UserController._();

  static UserController get con => _this;

  bool apiCall = false;
  String errorMsg = "";
  bool error = true;
  File imageProfile;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
//  final FacebookLogin facebookLogin = FacebookLogin();

  String imageUrl;

  Future<FirebaseUser> googleSignin(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final AuthResult authResult = await _auth.signInWithCredential(credential);

    FirebaseUser user = authResult.user;

    print("User is: ${user.uid} + ${user.email}");

    setState(() {
      imageUrl = user.photoUrl;
    });

    if (user.email != null) {
      UserLocalStorage()
          .saveGoogleName(user.displayName, user.photoUrl, user.uid)
          .then((done) {
        hasSocialOrNow(context, user.uid).then((hasSocialResponse) {
          print("response hasSocial is :::::::::::::::: " +
              hasSocialResponse.toString());
          if (hasSocialResponse[0] != "0") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BubblesScreen(
                  phone: hasSocialResponse[1],
                  googleInfo: [user.displayName, user.photoUrl, user.uid],
                ),

              ),
                  (Route<dynamic> route) => false,
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SocialDataScreen(
                  phone: user.phoneNumber,
                  googleInfo: [user.displayName, user.photoUrl, user.uid],
                ),
              ),
            );
          }
        });
      });
    }

    return user;
  }

  googleSignOut(BuildContext context) {
    setState(() {
      googleSignIn.signOut();
      imageUrl = null;
    });

    print("sign out ${imageUrl.toString()}");
  }

/*******************************************************************************/
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  facebookLogout(BuildContext context) async {
    await facebookSignIn.logOut();
    // onLoginStatusChanged(false);
    print("Logged out");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => GustScreen()),
      (Route<dynamic> route) => false,
    );
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  String _message = 'Log in/out by pressing the buttons below.';
  faceLogin(BuildContext context) async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    print(result.status.toString());
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        if (accessToken != null) {
          _showMessage('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

          var graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,'
              ' email,picture.width(400)&access_token=${accessToken.token}');

          var profile = json.decode(graphResponse.body);
          print(profile['phone'].toString());

          UserLocalStorage()
              .savefacebookInfo(
                  profile['name'].toString(),
                  profile['picture']['data']['url'].toString(),
                  accessToken.userId)
              .then((done) {
            hasSocialOrNow(context, accessToken.userId)
                .then((hasSocialResponse) {
              print("response hasSocial is :::::::::::::::: " +
                  hasSocialResponse.toString());
              if (hasSocialResponse[0] != "0") {

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BubblesScreen(
                      phone: hasSocialResponse[1],
                      googleInfo: [
                        profile['name'].toString(),
                        profile['picture']['data']['url'].toString(),
                        accessToken.userId
                      ],
                    ),
                  ),
                      (Route<dynamic> route) => false,
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SocialDataScreen(
                      googleInfo: [
                        profile['name'].toString(),
                        profile['picture']['data']['url'].toString(),
                        accessToken.userId
                      ],
                    ),
                  ),
                );
              }
            });
          });
        } else {
          print(accessToken.toString());
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }

// final existingToken = await facebookSignIn.currentAccessToken;
// if (existingToken != null) {

//  print("hello");

//  facebookSignIn.logOut();
//  // Reuse existing access token, no need to sign in just now
// } else {
// facebookSignIn.logIn(['email']).then((resualt) {
//      print(resualt.status.toString());
//      switch (resualt.status) {
//        case FacebookLoginStatus.loggedIn:
//          final AuthCredential credential = FacebookAuthProvider.getCredential(
//              accessToken: resualt.accessToken.token);
//          _auth.signInWithCredential(credential).then((signedInUser) {
//            print("sign in as ${signedInUser.user.displayName}");

//            Navigator.pushReplacement(context,
//                MaterialPageRoute(builder: (context) => BubblesScreen(
//                   phone: signedInUser.user.phoneNumber,
//                    firstName:"${signedInUser.user.displayName} ",
//                )));
//          }).catchError((e) {
//            print("login error :::::::" + e.toString());
//          });
//          break;
//        case FacebookLoginStatus.cancelledByUser:
//          print(
//              "Status Canceled :::::::${FacebookLoginStatus.cancelledByUser}");
//          break;
//        case FacebookLoginStatus.error:
//          print(" Status Error :::::::${FacebookLoginStatus.error}");
//          break;
//      }

//    }).catchError((e) {
//      print(e);
//    });

// }
  }

  void initiateFacebookLogin() async {
    bool isLoggedIn = false;

    void onLoginStatusChanged(bool isLoggedIn) {
      setState(() {
//        this.isLoggedIn = isLoggedIn;
      });
    }

    FacebookLogin facebookLogin = new FacebookLogin();
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        onLoginStatusChanged(true);
        break;
    }
  }
/************************************/

  Future getImageProfile() async {
    var imagex = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageProfile = imagex;
    });
    refresh();

    imageProfile.exists().then((yas) {
      print(yas);
      if (yas) {
        //  updateImage();
      }
    });
  }

  final url = ConstantVarable.apiUrl;

  @override
  Future<ServerResponseRegisterPhone> registerWithPhone(
      BuildContext context, String phone, bool isloading) async {
    return await http.post(
      "${url}registerPhone?phone=${phone.toString()}",
      headers: {
        "lang": AppModel().appLocal.toString(),
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final responseJson = json.decode(utf8.decode(response.bodyBytes));
        print("respnse json $responseJson");
        if (responseJson['success'] == "1") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VerificationCodeScreen(
                        phone: responseJson['data']['phone'],
                        forgot_or_register: "register",
                      )));
        }
        setState(() {
          errorMsg = responseJson['message'];
        });
        return ServerResponseRegisterPhone.fromJson(responseJson);
      } else {
        return ServerResponseRegisterPhone();
      }
    });
  }

  final registerStream = StreamController.broadcast();
  @override
  Future<UserModel> registerWithPassword(
      BuildContext context, String phone, String pass) async {
    return await http.post(
      "${url}registerPassword?phone=$phone&password=$pass",
      headers: {
        "lang": ConstantVarable.constantLang,
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final responseJson = json.decode(utf8.decode(response.bodyBytes));
        registerStream.sink.add(responseJson['data']);
        print("respnse json ${responseJson['data']}");
        return UserModel.fromJson(responseJson['data']);
      } else {
        return UserModel();
      }
    });
  }

  @override
  Future<UserModel> loginWithPhoneAndPassword(String phone, String pass) async {
    return await http.post(
      "${url}postLogin?phone=$phone&password=$pass",
      headers: {
        "lang": ConstantVarable.constantLang,
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final responseJson = json.decode(utf8.decode(response.bodyBytes));

        print("respnse json $responseJson");
        if (responseJson['success'] != "0") {
          return UserModel.fromJson(responseJson['data']);
        } else {
          print("respnse json ${responseJson['message']}");
          return UserModel.fromJson(responseJson);
        }
      } else {
        return UserModel();
      }
    });
  }

  Future registerPhone(
      BuildContext context, String phone, bool isloading) async {
    final form = ConstantVarable.registerPhoneFormKey.currentState;
    ConstantVarable.regAutoValid = true;

    if (form.validate()) {
      form.save();
      registerWithPhone(context, phone, isloading).then((response) {
        print("${response.message}");
        setState(() {
          errorMsg = response.message;
        });
      });
    } else {
      setState(() {
        form.save();
      });
    }
  }

  Future register(BuildContext context, String phone, String pass) async {
    final form = ConstantVarable.regformKey.currentState;
    ConstantVarable.regAutoValid = true;

    if (form.validate()) {
      form.save();
      registerWithPassword(context, phone, pass).then((response) {
        UserLocalStorage().saveClient(response).then((user) {
          if (user == true) {
            print("saved complited 00000000000000" + response.id.toString());
            ConstantVarable().constantPhone = response.phone;
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => BubblesScreen(
                          phone: response.phone,
                          firstName: response.first_name,
                          lastName: response.last_name,
                          userImage: response.image,
                          userId: response.id,
                        )),
                  (Route<dynamic> route) => false,
            );
          }
        }, onError: (error) {
          print("local Error ***********************");
          print(error);
        });
      });
    } else {
      setState(() {
        form.save();
      });
    }
  }

  Future logIn(BuildContext context, String phone, String pass) async {
    final form = ConstantVarable.loginformKey.currentState;
    ConstantVarable.loginAutoValid = true;

    if (form.validate()) {
      form.save();
      loginWithPhoneAndPassword(phone, pass).then((response) {
        setState(() {
          errorMsg = response.messageError;
        });
        UserLocalStorage().saveClient(response).then((user) {
          if (response.id != null) {
            print("saved complited 00000000000000" + response.lang.toString());
            ConstantVarable().constantPhone = response.phone;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BubblesScreen(
                        phone: response.phone,
                        firstName: response.first_name,
                        lastName: response.last_name,
                        userImage: response.image,
                        userId: response.id,
                      )),
                    (Route<dynamic> route) => false,
            );
          }
        }, onError: (error) {
          print("local Error ***********************");
          print(error);
        });
      });
    } else {
      setState(() {
        form.save();
      });
    }
  }

  Future forgotPasswordLogic(BuildContext context, String phone) async {
    final form = ConstantVarable.updateFormKey.currentState;
    ConstantVarable.updateAutoValid = true;

    if (form.validate()) {
      form.save();
      forgotPassword(phone, context);
    } else {
      setState(() {
        form.save();
      });
    }
  }

  @override
  Future<UserModel> forgotPassword(String phone, BuildContext context) async {
    return await http.post(
      "${url}forgetPassword?phone=$phone",
      headers: {
        "lang": ConstantVarable.constantLang,
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final responseJson = json.decode(utf8.decode(response.bodyBytes));
        print("respnse json ${responseJson['data']}");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => VerificationCodeScreen(
                      forgot_or_register: "forgot",
                      phone: responseJson['data']['phone'],
                    )));
        return UserModel.fromJson(responseJson['data']);
      } else {
        return UserModel();
      }
    });
  }

  @override
  Future<UserModel> newPassword(String phone, String pass) async {
    return await http.post(
      "${url}updatePassword?phone=$phone&password=$pass",
      headers: {
        "lang": ConstantVarable.constantLang,
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final responseJson = json.decode(utf8.decode(response.bodyBytes));
        print("respnse json ${responseJson['data']}");

        return UserModel.fromJson(responseJson['data']);
      } else {
        return UserModel();
      }
    });
  }

  Future updatePassword(BuildContext context, String phone, String pass) async {
    final form = ConstantVarable.updateFormKey.currentState;
    ConstantVarable.updateAutoValid = true;

    if (form.validate()) {
      form.save();
      newPassword(phone, pass).then((response) {
        UserLocalStorage().saveClient(response).then((user) {
          if (response.id != null) {
            print("saved complited 00000000000000" + response.id.toString());

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => BubblesScreen(
                          phone: response.phone,
                          firstName: response.first_name,
                          lastName: response.last_name,
                          userImage: response.image,
                          userId: response.id,
                        )),
                  (Route<dynamic> route) => false,);
          }
        }, onError: (error) {
          print("local Error ***********************");
          print(error);
        });
      });
    } else {
      setState(() {
        form.save();
      });
    }
  }

  Future<UserModel> updateProfileData(String phone, String first_name,
      String last_name, File image, BuildContext context) async {
    Dio dio = Dio();
    FormData formdata = FormData();
    if (image != null) {
      formdata.add(
        "image",
        new UploadFileInfo(
          image,
          basename(image.path),
        ),
      );
    } else {
      print("image is null");
    }
    formdata.add("phone", phone);
    formdata.add("first_name", first_name);
    formdata.add("last_name", last_name);
    formdata.add("consumerKey", "9a2ee795-67d0-4bc2-8852-17a809f02f3f");

    return await dio.post("${url}profileData", data: formdata).then((response) {
      print("data" + formdata.toString());
      if (response.statusCode == 200) {
        var jsonValue = jsonDecode(response.data);
        print("update profile respose is ::::::::: " + jsonValue.toString());

        return UserModel.fromJson(jsonValue['data']);
      } else {
        return UserModel();
      }
    }, onError: (error) {
      print("Error ::::: update profile response is :::: $error");
    });
  }

  Future updateProfileLogic(String phone, String first_name, String last_name,
      File image, BuildContext context) async {
    updateProfileData(phone, first_name, last_name, image, context)
        .then((response) {
      UserLocalStorage().saveClient(response).then((user) {
        if (response.id != null) {
          print("saved complited 00000000000000" + response.lang.toString());
          ConstantVarable().constantPhone = response.phone;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BubblesScreen(
                        phone: response.phone,
                        firstName: response.first_name,
                        lastName: response.last_name,
                        userImage: response.image,
                        userId: response.id,
                      )),
                (Route<dynamic> route) => false,);
        }
      }, onError: (error) {
        print("local Error ***********************");
        print(error);
      });
    });
  }

  final resendCodeStream = StreamController.broadcast();
  void resendCodeVerification(String phone) async {
    await http.post(
      "${url}resendCode?phone=$phone",
      headers: {
        "lang": ConstantVarable.constantLang,
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        print("resendCode respose is ::::::::: " + response.body.toString());
        resendCodeStream.sink.add(jsonDecode(response.body)['data']);
      }
    }, onError: (error) {
      resendCodeStream.close();
      print("resendCode response is :::: $error");
    });
  }

  final socialDataStream = StreamController.broadcast();
  @override
  Future<String> socialData(BuildContext context, String phone, String name,
      String image, String userId) async {
    return await http.post(
      "${url}socialData?phone=$phone&name=$name&image=$image&social_id=$userId",
      headers: {"consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"},
    ).then((response) {
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        socialDataStream.sink.add(responseJson['data']);
        print("social data is  ${responseJson['data']}");
        print("social data is  ${responseJson['message']}");
        String errorMessage = responseJson['message'];
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => BubblesScreen(
                      phone: phone,
                      googleInfo: [name, image, phone],
                    )),
              (Route<dynamic> route) => false,);
        return errorMessage;
      } else {
        return "error";
      }
    });
  }

  Future socialDataLogic(BuildContext context, String phone, String name,
      String image, String userId) async {
    final form = ConstantVarable.socialFormKey.currentState;
    ConstantVarable.socialAutoValid = true;

    if (form.validate()) {
      form.save();
      socialData(context, phone, name, image, userId).then((response) {
        print("message is " + response.toString());
      });
    } else {
      setState(() {
        form.save();
      });
    }
  }

  final hasSocialOrNowStream = StreamController.broadcast();

  Future<List<String>> hasSocialOrNow(BuildContext context, String socialId) async {
    return await http.post(
      "${url}checkHasSocial?social_id=$socialId",
      headers: {"consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"},
    ).then((response) {
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        hasSocialOrNowStream.sink.add(responseJson['data']);
        print("social data is  ${responseJson['data']}");
        print("social data is  ${responseJson['hasSocial']}");
        List<String> socialResponse = [responseJson['hasSocial'].toString(),responseJson['data']['phone'].toString()];
        return socialResponse;
      } else {
        hasSocialOrNowStream.close();
        return ["error" , "error"];
      }
    });
  }

  Widget showErrorMsg() {
    return Text(
      errorMsg ?? "",
      style: new TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String validateUserName(String val) {
    if (val.trim().isEmpty) {
      return "من فضلك ادخل اسم المستحدم";
    } else
      return null;
  }

  String validatePhone(String val) {
    if (val.trim().isEmpty) {
      return "please enter your phone numper";
    } else
      return null;
  }

  String validateEmail(String val) {
    if (val.isEmpty)
      return "ادخل البريد الالكترونى";
    else {
      final _emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
          r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
      if (!RegExp(_emailRegExpString, caseSensitive: false).hasMatch(val)) {
        return "البريد الاكترونى غير صالح";
      } else
        return null;
    }
  }

  String validatePassword(String val) {
    if (val.trim().isEmpty)
      return "Please enter the password";
    else if (val.length < 8) {
      return "The password is less than 8 Letters";
    } else
      return null;
  }

  String validateStudentCode(String val) {
    if (val.trim().isEmpty)
      return "من فضلك ادخل كود الطالب";
    else
      return null;
  }

  String validateConfirmPassword(String val) {
    if (val.trim().isEmpty)
      return "Please enter the password";
    else if (val != ConstantVarable.passwordController.text) {
      return "The password does not match";
    } else
      return null;
  }

  void clearTextEditing() {
    ConstantVarable.phoneControllerReg.clear();
    ConstantVarable.phoneControllerLog.clear();
    ConstantVarable.passwordController.clear();
    ConstantVarable.confirmPasswordController.clear();
  }
}
