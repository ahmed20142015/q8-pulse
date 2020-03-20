import 'dart:async';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:q8_pulse/ConstantVarables.dart';
class GalleryController extends ControllerMVC {
  factory GalleryController() {
    if (_this == null) _this = GalleryController._();
    return _this;
  }
  static GalleryController _this;

  GalleryController._();
 

  static GalleryController get con => _this;
  static final url = ConstantVarable.apiUrl;

  final getGalleryStream = StreamController.broadcast();
  void getGallery() async {
    await http.post("${url}getGallery", headers: {
      "lang":   ConstantVarable.constantLang==null ? "en" : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
    }).then((response) {
      if (response.statusCode == 200) {
        print(" respose is ::::::::: " + response.body[1].toString());
        getGalleryStream.sink.add(jsonDecode(response.body)['data']);
      }
    }, onError: (error) {
      getGalleryStream.close();
      print("response is :::: $error");
    });
  }


}
