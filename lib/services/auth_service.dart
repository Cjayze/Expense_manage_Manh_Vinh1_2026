import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  static const String _authBoxName = "auth_box";
  static const String _isLoggedInKey = "is_logged_in";
  static const String _usernameKey = "username";
  static const String _emailKey = "email";

  static final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);
  static String currentUsername = "Đăng nhập";
  static String currentEmail = "Đăng nhập, thú vị hơn!";

  static Future<void> init() async {
    await Hive.openBox(_authBoxName);
    final box = Hive.box(_authBoxName);
    
    isLoggedIn.value = box.get(_isLoggedInKey, defaultValue: false);
    currentUsername = box.get(_usernameKey, defaultValue: "Đăng nhập");
    currentEmail = box.get(_emailKey, defaultValue: "Đăng nhập, thú vị hơn!");
  }

  static Future<void> login(String username, String email) async {
    final box = Hive.box(_authBoxName);
    await box.put(_isLoggedInKey, true);
    await box.put(_usernameKey, username);
    await box.put(_emailKey, email);

    currentUsername = username;
    currentEmail = email;
    isLoggedIn.value = true;
  }

  static Future<void> logout() async {
    final box = Hive.box(_authBoxName);
    await box.put(_isLoggedInKey, false);
    await box.put(_usernameKey, "Đăng nhập");
    await box.put(_emailKey, "Đăng nhập, thú vị hơn!");

    currentUsername = "Đăng nhập";
    currentEmail = "Đăng nhập, thú vị hơn!";
    isLoggedIn.value = false;
  }
}