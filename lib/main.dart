import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';

import 'screens/main_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions
            .currentPlatform,
  );

  await DatabaseService.init();

  await AuthService.init();

  if (AuthService.isLoggedIn.value) {
    await DatabaseService.syncFromFirebase();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false,
      title: 'Sổ Thu Chi',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor:
            const Color(0xFF121212),
      ),
      home:
          ValueListenableBuilder<bool>(
        valueListenable:
            AuthService.isLoggedIn,
        builder: (
          context,
          isLoggedIn,
          _,
        ) {
          return isLoggedIn
              ? const MainScreen()
              : LoginScreen();
        },
      ),
    );
  }
}