import 'package:q8_pulse/Data/Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:q8_pulse/Data/Models/NotificationModel.dart';

class UserLocalStorage {
  Future<bool> saveNotifications1(int notificationId , bool notified) async {
    print("befor save   $notificationId");
    print("********* FROM THE RESPONSE ********* save   $notified");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setInt("id", notificationId);
      await prefs.setBool("notified", notified);
      return true;
    } catch (e) {
      print("save to shared faild   :  $e");
      return false;
    }
  }
  Future<bool> saveNotifications$id(int notificationId , bool notified) async {
    print("befor save   $notificationId");
    print("********* FROM THE RESPONSE ********* save   $notified");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setInt("id", notificationId);
      await prefs.setBool("notified", notified);
      return true;
    } catch (e) {
      print("save to shared faild   :  $e");
      return false;
    }
  }

  Future<List<String>> getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final notificationId = prefs.getString('id');
    final notified = prefs.getString('notified');
    return [notificationId,notified];
  }
 Future<bool> saveClient(UserModel user) async {
    print("befor save   ${user.phone}");
    print("********* FROM THE RESPONSE ********* save   ${user.lang}");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setInt("id", user.id);
      await prefs.setString("first_name", user.first_name);
      await prefs.setString("last_name", user.last_name);
      await prefs.setString("phone", user.phone);
      await prefs.setString("image", user.image);
      await prefs.setInt("is_verified", user.is_verified);
      await prefs.setString("lang", user.lang);
      //await prefs.setString("imgPath", user.);
      print("saved data ${user.id}+${user.phone} +${user.is_verified}");
      return true;
    } catch (Excption) {
      print("save to shared faild   :  $Excption");
      return false;
    }
  }

  Future<UserModel> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return new UserModel(
        id: prefs.getInt("id"),
        first_name: prefs.getString("first_name"),
        last_name: prefs.getString("last_name"),
        phone: prefs.getString("phone"),
        image: prefs.getString("image"),
        is_verified: prefs.getInt("is_verified"),
        lang: prefs.getString("lang"));
  }

  Future<bool> saveGoogleName(String nameGoogle , String imageGoogle , String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(nameGoogle!=null){
    prefs.setString('name', nameGoogle);
    prefs.setString('image', imageGoogle);
    prefs.setString('user_id', userId);
    return true;
    }else{
return false;
    }


  }

  Future<List<String>> getGoogleName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final googleName = prefs.getString('name');
    final googleImage = prefs.getString('image');
    final userId = prefs.getString('user_id');
    print("get google name  $googleName $googleImage $userId");
    return [googleName , googleImage , userId ];
  }

   Future<bool> savefacebookInfo(String nameFace , String imageFace , String userIdFace) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(nameFace!=null){
    prefs.setString('name', nameFace);
    prefs.setString('image', imageFace);
    prefs.setString('user_id', userIdFace);
    return true;
    }else{
return false;
    }


  }

  Future<List<String>> getFacebookInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final nameFace = prefs.getString('name');
    final imageFace = prefs.getString('image');
    final userIdFace = prefs.getString('user_id');
    print("get google name  $nameFace $imageFace $userIdFace");
    return [nameFace , imageFace , userIdFace ];
  }

  //   Future<bool> saveShows(ShowModel show) async {
  //   print("befor save   ${show.id}");
  //   print("********* FROM THE RESPONSE ********* save   ${show.id}");
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();

  //     await prefs.setInt("id", show.id);
  //     await prefs.setString("title_en", show.titleEn);
  //     await prefs.setString("pivot"[''], show.pivot.fromTime);

  //     print("saved data ${show.id}+${show.pivot} ");
  //     return true;
  //   } catch (Excption) {
  //     print("save to shared faild   :  $Excption");
  //     return false;
  //   }
  // }

  // Future<ShowModel> getShow() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   return new ShowModel(
  //     id: prefs.getInt("id"),
  //     titleEn: prefs.getString("titleEn"),

  //   );
  // }

  Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return true;
  }
}
