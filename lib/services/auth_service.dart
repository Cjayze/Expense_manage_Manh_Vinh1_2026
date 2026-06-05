import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static final ValueNotifier<bool> isLoggedIn =
      ValueNotifier<bool>(false);

  static String currentUsername = "Đăng nhập";
  static String currentEmail = "";

  static Future<void> init() async {
    final user = _auth.currentUser;

    if (user != null) {
      isLoggedIn.value = true;
      currentEmail = user.email ?? "";
      currentUsername =
          user.displayName ?? user.email ?? "Người dùng";
    }
  }

  static Future<void> register(
    String username,
    String email,
    String password,
  ) async {
    final credential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user!.updateDisplayName(username);

    currentUsername = username;
    currentEmail = email;

    isLoggedIn.value = true;
  }

  static Future<void> login(
    String email,
    String password,
  ) async {
    final credential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    currentUsername =
        credential.user?.displayName ??
        credential.user?.email ??
        "";

    currentEmail =
        credential.user?.email ?? "";

    isLoggedIn.value = true;
  }

  static Future<void> logout() async {
    await _auth.signOut();

    currentUsername = "Đăng nhập";
    currentEmail = "";

    isLoggedIn.value = false;
  }

  static String? get uid {
    return _auth.currentUser?.uid;
  }
}