import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Data/Models/ShowModel.dart';

// import '../Data/Models/Locatuion.dart';

class ShowsController extends ControllerMVC {
  //to make single instance of class
  factory ShowsController() {
    if (_this == null) _this = ShowsController._();
    return _this;
  }
  static ShowsController _this;

  ShowsController._();

  static ShowsController get con => _this;
  static final url = ConstantVarable.apiUrl;

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
      print("response is :::: $error");
    });
  }

  final getShowPresentersStream = StreamController.broadcast();
  void getShowPresenters(String showId) async {
    await http.post(
      "${url}getShowPresenters?show_id=${showId.toString()}",
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
        getShowPresentersStream.sink.add(responseJson['data']);
      }
    }, onError: (error) {
      getShowPresentersStream.close();
      print("response is :::: $error");
    });
  }

  final getAllShowsStream = StreamController.broadcast();
  void getAllShows(BuildContext context) async {
    print("getAllShows Method");
    await http.post("${url}getAllShows", headers: {
      "lang": ConstantVarable.constantLang == null
          ? "en"
          : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
    }).then((response) {
      if (response.statusCode == 200) {
        print(" All Shows respose is ::::::::: " + response.body.toString());
        var responseJson = jsonDecode(response.body);
        getAllShowsStream.sink.add(responseJson['data']);
      }
    }, onError: (error) {
      getAllShowsStream.close();
      print(" All Shows response is :::: $error");
    });
  }

  final getAirTimeStream = StreamController.broadcast();
  Future<List<String>> getAirTimes(String showId) async {
    return await http.post("${url}getShowTimes", headers: {
      "lang": ConstantVarable.constantLang == null
          ? "en"
          : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f",
    }, body: {
      "show_id": showId,
    }).then((response) {
      if (response.statusCode == 200) {
        print(" respose is ::::::::: " + response.body.toString());
        var jsonValue = jsonDecode(response.body);
        getAirTimeStream.sink.add(jsonValue['data']);
        List<dynamic> airTimeList = jsonValue['data'];
        List<String> fromTimes = List();
        for (int i = 0; i < airTimeList.length; i++) {
          fromTimes.add(jsonValue['data'][i]['from_time'].toString());
        }

        print(fromTimes);

        return fromTimes;
      } else {
        return [];
      }
    }, onError: (error) {
      getAirTimeStream.close();
      print("response is :::: $error");
    });
  }

  final getAirTimeStream2 = StreamController.broadcast();
  Future<List<String>> getAirTimes2(String showId) async {
    return await http.post("${url}getShowTimes", headers: {
      "lang": ConstantVarable.constantLang == null
          ? "en"
          : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f",
    }, body: {
      "show_id": showId,
    }).then((response) {
      if (response.statusCode == 200) {
        print(" respose is ::::::::: " + response.body.toString());
        var jsonValue = jsonDecode(response.body);
        getAirTimeStream2.sink.add(jsonValue['data']);
        List<dynamic> airDaysList = jsonValue['data'];
        List<String> days = List();
        for (int i = 0; i < airDaysList.length; i++) {
          days.add(jsonValue['data'][i]['name'].toString());
        }

        print(days);

        return days;
      } else {
        return [];
      }
    }, onError: (error) {
      getAirTimeStream2.close();
      print("response is :::: $error");
    });
  }

  final getAllAddsStream = StreamController.broadcast();
  void getAllAdds(String showId) async {
    await http.post(
      "${url}getShowAds?show_id=$showId",
      headers: {
        "lang": ConstantVarable.constantLang == null
            ? "en"
            : ConstantVarable.constantLang,
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        print("Shows Adds respose is ::::::::: " + response.body.toString());
        getAllAddsStream.sink.add(jsonDecode(response.body)['data']);
      }
    }, onError: (error) {
      getAllAddsStream.close();
      print("Shows Adds response is :::: $error");
    });
  }

  Future<List<ShowModel>> showsForBabbles() async {
    return await http.post(
      "${url}getAllShows",
      headers: {
        "lang": ConstantVarable.constantLang,
        "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final responseJson = json.decode(utf8.decode(response.bodyBytes));
        print("respnse shows babbles json ${responseJson['data']}");
        return (responseJson as List)
            .map((f) => new ShowModel.fromJson(f))
            .toList();
      } else {
        return List<ShowModel>();
      }
    });
  }

  final getAllShowsStream2 = StreamController.broadcast();
  void getAllShows2() async {
    print("getAllShows Method");
    await http.post("${url}getAllShows", headers: {
      "lang": ConstantVarable.constantLang == null
          ? "en"
          : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f"
    }).then((response) {
      if (response.statusCode == 200) {
        print(" All Shows respose is ::::::::: " + response.body.toString());
        var responseJson = jsonDecode(response.body);
        getAllShowsStream2.sink.add(responseJson['data']);

        for (int i = 0; i < 3; i++) {
          getAllAdds(responseJson['data'][i]['id'].toString());
          getAirTimes(responseJson['data'][i]['id'].toString());
        }

//  getAllAdds(responseJson['data'][0]['id'].toString());

      }
    }, onError: (error) {
      getAllShowsStream2.close();
      print(" All Shows response is :::: $error");
    });
  }
}
