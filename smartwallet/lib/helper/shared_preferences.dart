import 'package:shared_preferences/shared_preferences.dart';

class SmartWalletSharedPref {
  SharedPreferences prefs;

  Future<SharedPreferences> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  saveStringValue(String data) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("privateKey", data);
  }

  Future<String> readStringValue(String key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
