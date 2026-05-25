import 'package:flutter/material.dart';
import 'pages/main_shell.dart';

void main() {
  runApp(const ExpenseManageApp());
}

class ExpenseManageApp extends StatelessWidget {
  const ExpenseManageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quan Ly Chi Tieu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}