import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService
{
  setSharedPreference(String key, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  Future<String> getSharedPreference(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString(key) ?? "";
  }
}
