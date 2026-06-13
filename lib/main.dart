import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/theme_service.dart';

import 'screens/main_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await DatabaseService.init();

  await ThemeService.init();

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
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeService.isDarkMode,
      builder: (context, isDark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sổ Thu Chi',

          theme: ThemeData(
            brightness: Brightness.light,
            colorSchemeSeed: Colors.amber,
            scaffoldBackgroundColor:
                Colors.grey.shade100,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            cardTheme: const CardThemeData(
              color: Colors.white,
            ),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.amber,
            scaffoldBackgroundColor:
                const Color(0xFF121212),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            cardTheme: const CardThemeData(
              color: Color(0xFF1E1E1E),
            ),
          ),

          themeMode:
              isDark ? ThemeMode.dark : ThemeMode.light,

          home: ValueListenableBuilder<bool>(
            valueListenable: AuthService.isLoggedIn,
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
      },
    );
  }
}
