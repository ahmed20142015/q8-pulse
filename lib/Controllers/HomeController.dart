import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Screens/bubbles.dart';
import 'package:q8_pulse/Screens/call.dart';
import 'package:q8_pulse/Widgets/SharedWidget.dart';
import 'package:share/share.dart';

class HomeController extends ControllerMVC {
  //to make single instance of class
  factory HomeController() {
    if (_this == null) _this = HomeController._();
    return _this;
  }
  static HomeController _this;

  HomeController._();

  static HomeController get con => _this;
  static final url = ConstantVarable.apiUrl;

  final getHomeAddsStream = StreamController.broadcast();
  void getAllAddsForHome() async {
    await http.post("${url}getHomeAds", headers: {
      "lang": ConstantVarable.constantLang == null
          ? "en"
          : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
    }).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(" All Adds respose is ::::::::: " + jsonResponse['data'].toString());
        getHomeAddsStream.sink.add(jsonResponse['data']);
      }
    }, onError: (error) {
//      getHomeAddsStream.close();
      print("response is :::: $error");
    });
  }

  final getAllPresentersStream = StreamController.broadcast();
  void getAllPresenters() async {
    await http.post("${url}getAllPresenters", headers: {
      "lang": ConstantVarable.constantLang == null
          ? "en"
          : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
    }).then((response) {
      if (response.statusCode == 200) {
        print(" respose is ::::::::: " + response.body.toString());
        getAllPresentersStream.sink.add(jsonDecode(response.body)['data']);
      }
    }, onError: (error) {
      getAllPresentersStream.close();
      print("All Presinters response is :::: $error");
    });
  }

  final getAllShowsForPresenterStream = StreamController.broadcast();
  void getAllShowsForPresenter(String presenterId) async {
    await http.post("${url}getPresenterShows", headers: {
      "lang": ConstantVarable.constantLang == null
          ? "en"
          : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f",
    }, body: {
      "presenter_id": presenterId
    }).then((response) {
      if (response.statusCode == 200) {
        print(" respose is ::::::::: " + response.body.toString());
        getAllShowsForPresenterStream.sink
            .add(jsonDecode(response.body)['data']);
      }
    }, onError: (error) {
      getAllShowsForPresenterStream.close();
      print("response is :::: $error");
    });
  }

  share(
    BuildContext context,
  ) {
    final RenderBox box = context.findRenderObject();

    Share.share( "Listen to Q8 Pulse FM88.8 Live Stream. "
        "Get the App now for FREE."
        "Apple Store: https://apps.apple.com/us/app/fm888/id1168544429",
        subject: " Q8 Pulse FM88.8 Live Stream",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  String _eventMessage;

  void onEvent(Object event) {
    setState(() {
      _eventMessage =
          "Battery status: ${event == 'charging' ? '' : 'dis'}charging.";
    });
  }

  void onError(Object error) {
    setState(() {
      _eventMessage = 'Battery status: unknown.';
    });
  }

  final getChatListStream = StreamController.broadcast();
  void getChatList(String phone) async {
    await http.post(
      "${url}getchats?phone=$phone",
      headers: {
        "lang": ConstantVarable.constantLang == null
            ? "en"
            : ConstantVarable.constantLang,
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body);
        print(" respose is ::::::::: " + responseJson['data'].toString());
        getChatListStream.sink.add(responseJson['data']);
      }
    }, onError: (error) {
      print("response is :::: $error");
      getChatListStream.close();
    });
  }

  final getwhatDisplayNowStream = StreamController.broadcast();
  void whatDisplayNow() async {
    await http.post(
      "${url}whatDisplayNow",
      headers: {
        "lang": ConstantVarable.constantLang == null
            ? "en"
            : ConstantVarable.constantLang,
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body);
        int showId = responseJson['data']['id'];

        getShowPresenters(showId);
        print(" whatDisplayNow  respose is ::::::::: " +
            responseJson['data'].toString());
        getwhatDisplayNowStream.sink.add(responseJson['data']);
      }
    }, onError: (error) {
      getwhatDisplayNowStream.close();
      print("response is :::: $error");
    });
  }

  final getShowPresentersStream = StreamController.broadcast();
  void getShowPresenters(int showId) async {
    await http.post(
      "${url}getShowPresenters?show_id=$showId",
      headers: {
        "lang": ConstantVarable.constantLang == null
            ? "en"
            : ConstantVarable.constantLang,
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body);
        print("show presinters respose is ::::::::: " + responseJson['data'].toString());
        getShowPresentersStream.sink.add(responseJson['data']);
      }
    }, onError: (error) {
      getShowPresentersStream.close();
      print("response is :::: $error");
    });
  }

  void sendChatRecord(String phone, File record) async {
    Dio dio = Dio();
    FormData formdata = FormData();

    formdata.add(
      "record_path",
      UploadFileInfo(
        record,
        basename(record.path),
      ),
    );
    formdata.add("phone", phone);
    await dio.post("${url}postchat", data: formdata).then((response) {
      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.data);
        print(" respose is ::::::::: " + responseJson['data'].toString());
      }
    }, onError: (error) {
      print("response is :::: $error");
    });
  }

  void sendChatMessage(String phone, String message) async {
    await http.post("${url}postchat?phone=$phone&message=$message", headers: {
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f",
    }).then((response) {
      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body);
        print("message is send " + responseJson['message'].toString());
      }
    }, onError: (error) {
      print("response is :::: $error");
    });
  }

  onJoin(BuildContext context, String phone , int guestId) async {
    // update input validation
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();
    print("done");

    ringTone().then((url){
      if(guestId!=015) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new CallPage(
                phone: phone,
                channelName: "user$phone",
                urlRingTone: "${ConstantVarable.apiImg}$url",
              )));}else{
        SharedWidget.dialogLogin(context);
      }
    });

  }

  _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
  }

  Future<int> postCall(String phone, String channelName) async {
  return await http
        .post("${url}call?userPhone=$phone&channelName=$channelName", headers: {
      "lang": ConstantVarable.constantLang == null
          ? "en"
          : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
    }).then((response) {
      if (response.statusCode == 200) {
         var jsonResponse = jsonDecode(response.body);
         print(" respose is ::::::::: " + jsonResponse.toString());
return jsonResponse['data'];

      }else{
        return 0;
      }
    }, onError: (error) {
      print("response is :::: $error");

    });
  }

  void startCall(int id,) async {
    await http
        .post("${url}startcall?id=$id", headers: {
      "lang": ConstantVarable.constantLang == null
          ? "en"
          : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
    }).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(" respose is ::::::::: " + jsonResponse['data'].toString());

      }
    }, onError: (error) {
      print("response is :::: $error");
    });
  }
  void endCall(int id,) async {
    await http
        .post("${url}endcall?id=$id", headers: {
      "lang": ConstantVarable.constantLang == null
          ? "en"
          : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
    }).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(" respose is ::::::::: " + jsonResponse['data'].toString());

      }
    }, onError: (error) {
      print("response is :::: $error");
    });
  }
  void missedCall(int id,) async {
    await http
        .post("${url}missedcall?id=$id", headers: {
      "lang": ConstantVarable.constantLang == null
          ? "en"
          : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
    }).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(" respose is ::::::::: " + jsonResponse['data'].toString());

      }
    }, onError: (error) {
      print("response is :::: $error");
    });
  }

  void chooseLang(String phone, String lang) async {
    print("change lnguage $lang ");
    await http.post("${url}chooselang?lang=$lang", headers: {
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
    }).then((response) {
      if (response.statusCode == 200) {
        print(" respose is ::::::::: " + response.body.toString());
      }
    }, onError: (error) {
      print("response is :::: $error");
    });
  }

  final videoDataStream = StreamController.broadcast();
  void getVideoData() async {
    await http.post(
      "${url}getVideoStream",
      headers: {
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonValue = jsonDecode(response.body);
        print(
            "video Data respose is ::::::::: " + jsonValue['data'].toString());
        videoDataStream.sink.add(jsonValue['data']);

        setState(() {
          ConstantVarable.videoUrl = jsonValue['data']['url'];
        });
      }
    }, onError: (error) {
      videoDataStream.close();
      print("video Data response is :::: $error");
    });
  }

  Future<String> ringTone() async {
    return await http.post(
      "${url}getRingTone",
      headers: {
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      },
    ).then((response) {
      var jsonValue = jsonDecode(response.body);
      String responseUrl = jsonValue['data']['url'];
      if (response.statusCode == 200) {
        print(
            "ringtone Data respose is ::::::::: " + jsonValue['data'].toString());
        return responseUrl;
      } else {
        return "";
      }
    });
  }
}
