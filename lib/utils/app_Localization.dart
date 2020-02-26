import 'package:flutter/material.dart';
import 'package:q8_pulse/utils/ar.dart';
import 'package:q8_pulse/utils/en.dart';

class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': EN.english,
    'ar': AR.arabic,
  };

  Map<String, String> get title {
    return _localizedValues[locale.languageCode];
  }

  String get login {
    return _localizedValues[locale.languageCode]['login'];
  }

  
  
}
