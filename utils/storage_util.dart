import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static final StorageHelper _singleton = StorageHelper._internal();
  factory StorageHelper() => _singleton;
  StorageHelper._internal();
  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    print("SharedPreferences initialized");
  }
  Future<void> logout() async {
    await prefs.remove('isLoggedIn');
  }

  Future<void> setBoolIsLoggedIn(bool value) async {
    print("📝 setBoolIsLoggedIn: $value");
    await prefs.setBool("isLoggedIn", value);
  }

  Future<bool> getBoolIsLoggedIn() async {
    final value = prefs.getBool("isLoggedIn") ?? false;
    print("📤 getBoolIsLoggedIn: $value");
    return value;
  }

  Future<void> setLoginUserId(String token) async {
    print("📝 setLoginUserName: $token");
    await prefs.setString('login_user_id', token);
  }

  Future<String> getLoginUserId() async {
    return prefs.getString('login_user_id') ?? "";
  }


  Future<void> setLoginUserName(String token) async {
    print("📝 setLoginUserName: $token");
    await prefs.setString('login_user_name', token);
  }

  Future<String> getLoginUserName() async {
    return prefs.getString('login_user_name') ?? "";
  }
}
