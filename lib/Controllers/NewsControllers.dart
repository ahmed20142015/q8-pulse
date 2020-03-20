import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:q8_pulse/ConstantVarables.dart';

import 'package:share/share.dart';
// import '../Data/Models/Locatuion.dart';

class NewsController extends ControllerMVC {
  //to make single instance of class
  factory NewsController() {
    if (_this == null) _this = NewsController._();
    return _this;
  }
  static NewsController _this;

  NewsController._();

  static NewsController get con => _this;
  static final url = ConstantVarable.apiUrl;

  final getAllNewsStream = StreamController.broadcast();
  void getAllNews() async {
    await http.post("${url}getAllNews", headers: {
      "lang":   ConstantVarable.constantLang==null ? "en" : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
    }).then((response) {
      if (response.statusCode == 200) {
        print(" respose is ::::::::: " + response.body[1].toString());
        getAllNewsStream.sink.add(jsonDecode(response.body)['data']);
      }
    }, onError: (error) {
      getAllNewsStream.close();
      print("response is :::: $error");
    });
  }



    share(
    BuildContext context,
  ) {
    final RenderBox box = context.findRenderObject();

    Share.share("Q8_pulse - https://www.q8-pulse.com",
        subject: "Q8_pulse",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }


}
