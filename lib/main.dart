import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'services/auth_service.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseService.init(); 
  await AuthService.init();     

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sổ Thu Chi',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme( 
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 0,
        ),
      ),
      home: const MainScreen(),
    );
  }
}