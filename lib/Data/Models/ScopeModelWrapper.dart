import 'package:flutter/material.dart';
import 'package:q8_pulse/ConstantVarables.dart';
import 'package:q8_pulse/Controllers/HomeController.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:q8_pulse/main.dart';

class ScopeModelWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(model: AppModel(), child: MyApp());
  }
}

class AppModel extends Model {
  Locale appLocale = Locale('en');
  Locale get appLocal => appLocale;


  void changeDirection(String phone) {
    print(appLocale);
    print('Scoped Model has been Invoked');
    if (appLocale == Locale("ar")) {
      appLocale = Locale("en");

      ConstantVarable.constantLang="en";
HomeController().chooseLang(phone, "en");
print("hello lang" + ConstantVarable.constantLang);
    } else {
      appLocale = Locale("ar");
      ConstantVarable.constantLang="ar";
      HomeController().chooseLang(phone, "ar");
      print("hello lang" + ConstantVarable.constantLang);
    }
    notifyListeners();
    print("$appLocale");


  }


}
