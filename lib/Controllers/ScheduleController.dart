import 'dart:async';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:q8_pulse/ConstantVarables.dart';
// import '../Data/Models/Locatuion.dart';

class ScheduleController extends ControllerMVC {
  //to make single instance of class
  factory ScheduleController() {
    if (_this == null) _this =ScheduleController._();
    return _this;
  }
  static ScheduleController _this;

  ScheduleController._();

  static ScheduleController get con => _this;
  static final url = ConstantVarable.apiUrl;

  final getScheduleStream1 = StreamController.broadcast();
  void getChedule_1() async {
    print(ConstantVarable.constantLang.toString());
    await http.post("${url}getDaySchedule", headers: {
      "lang":   ConstantVarable.constantLang==null ? "en" : ConstantVarable.constantLang,
      "consumerKey":"9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      "day": "1"
    }).then((response) {
      if (response.statusCode == 200) {
        print("${url}getDaySchedule");
        
        var responseData = jsonDecode(response.body);
        print(" respose is :::::::::data is " + responseData['data'].toString());
        getScheduleStream1.sink.add(responseData['data']);
      }
    }, onError: (error) {
      getScheduleStream1.close();
      print("response is :::: $error");
    });
  }



    final getScheduleStream2 = StreamController.broadcast();
  void getChedule_2() async {
    await http.post("${url}getDaySchedule", headers: {
      "lang":   ConstantVarable.constantLang==null ? "en" : ConstantVarable.constantLang,
      "consumerKey":"9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      "day": "2"
    }).then((response) {
      if (response.statusCode == 200) {
        var josnRespons = jsonDecode(response.body);
        print(" respose is ::::::::: " + josnRespons['data'].toString());
        getScheduleStream2.sink.add(josnRespons['data']);

       
      }
    }, onError: (error) {
      getScheduleStream2.close();
      print("response is :::: $error");
    });
  }



    final getScheduleStream3 = StreamController.broadcast();
  void getChedule_3() async {
    await http.post("${url}getDaySchedule", headers: {
      "lang":   ConstantVarable.constantLang==null ? "en" : ConstantVarable.constantLang,
      "consumerKey":"9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      "day": "3"
    }).then((response) {
      if (response.statusCode == 200) {
        print(" respose is ::::::::: " + response.body.toString());
        getScheduleStream3.sink.add(jsonDecode(response.body)['data']);
      }
    }, onError: (error) {
      getScheduleStream3.close();
      print("response is :::: $error");
    });
  }


    final getScheduleStream4 = StreamController.broadcast();
  void getChedule_4() async {
    await http.post("${url}getDaySchedule", headers: {
      "lang":   ConstantVarable.constantLang==null ? "en" : ConstantVarable.constantLang,
      "consumerKey":"9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      "day": "4"
    }).then((response) {
      if (response.statusCode == 200) {
        print(" respose is ::::::::: " + response.body.toString());
        getScheduleStream4.sink.add(jsonDecode(response.body)['data']);
      }
    }, onError: (error) {
      getScheduleStream4.close();
      print("response is :::: $error");
    });
  }



    final getScheduleStream5 = StreamController.broadcast();
  void getChedule_5() async {
    await http.post("${url}getDaySchedule", headers: {
      "lang":   ConstantVarable.constantLang==null ? "en" : ConstantVarable.constantLang,
      "consumerKey":"9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      "day": "5"
    }).then((response) {
      if (response.statusCode == 200) {
        print(" respose is ::::::::: " + response.body.toString());
        getScheduleStream5.sink.add(jsonDecode(response.body)['data']);
      }
    }, onError: (error) {
      getScheduleStream5.close();
      print("response is :::: $error");
    });
  }


    final getScheduleStream6 = StreamController.broadcast();
  void getChedule_6() async {
    await http.post("${url}getDaySchedule", headers: {
      "lang":   ConstantVarable.constantLang==null ? "en" : ConstantVarable.constantLang,
      "consumerKey":"9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      "day": "6"
    }).then((response) {
      if (response.statusCode == 200) {
        print(" respose is ::::::::: " + response.body.toString());
        getScheduleStream6.sink.add(jsonDecode(response.body)['data']);
      }
    }, onError: (error) {
      getScheduleStream6.close();
      print("response is :::: $error");
    });
  }


    final getScheduleStream7 = StreamController.broadcast();
  void getChedule_7() async {
    await http.post("${url}getDaySchedule", headers: {
      "lang":   ConstantVarable.constantLang==null ? "en" : ConstantVarable.constantLang,
      "consumerKey":"9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      "day": "7"
    }).then((response) {
      if (response.statusCode == 200) {
        print(" respose is ::::::::: " + response.body.toString());
        getScheduleStream7.sink.add(jsonDecode(response.body)['data']);
      }
    }, onError: (error) {
      getScheduleStream7.close();
      print("response is :::: $error");
    });
  }

      final getScheduleForAddsStream = StreamController.broadcast();
  void getCheduleforAdds(String day , String time) async {
    await http.post("${url}getDaySchedule", headers: {
      "lang":   ConstantVarable.constantLang==null ? "en" : ConstantVarable.constantLang,
      "consumerKey":"9a2ee795-67d0-4bc2-8852-17a809f02f3f",
      "day": day
    }).then((response) {
      if (response.statusCode == 200) {
        var josnRespons = jsonDecode(response.body);
         List<dynamic> showsList = josnRespons['data'];
        print( " عدد القائمه "+ showsList.length.toString());
        print(" respose is ::::::::: " + josnRespons['data'].toString());
        getScheduleForAddsStream.sink.add(josnRespons['data']);
       
for (int index = 0 ; index < showsList.length ; index++  ){
if (time == showsList[index]['pivot']['from_time']) {

  getAllAdds(showsList[index]['id']);
  
}else{
  getScheduleForAddsStream.close();
  print("time is not equal xxxxxxxxxxxxxxxxxxxxxxxxx");
}
 
}
       
      }
    }, onError: (error) {
      print("response is :::: $error");
    });
  }

      final getAllAddsStream = StreamController.broadcast();
  void getAllAdds(String showId) async {
    await http.post("${url}getShowAds?show_id=$showId", headers: {
      "lang":   ConstantVarable.constantLang==null ? "en" : ConstantVarable.constantLang,
      "consumerKey": "9a2ee795-67d0-4bc2-8852-17a809f02f3f",
    }, ).then((response) {
      if (response.statusCode == 200) {
        print("Shows Adds respose is ::::::::: " + response.body.toString());
        getAllAddsStream.sink.add(jsonDecode(response.body)['data']);
      }
    }, onError: (error) {
      getAllAddsStream.close();
      print("Shows Adds response is :::: $error");
    });
  }





}
