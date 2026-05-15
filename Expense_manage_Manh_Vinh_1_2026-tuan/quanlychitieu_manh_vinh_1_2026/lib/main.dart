import 'package:flutter/material.dart';
// Import đúng file chứa giao diện
import 'expense_home_page.dart'; 

void main() {
  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản Lý Chi Tiêu',
      theme: ThemeData(
        useMaterial3: true,
        // Chỉnh màu xanh lá giống thiết kế của bạn
        colorSchemeSeed: const Color(0xFF2D5A27), 
      ),
      // Gọi đúng tên Class từ file expense_home_page.dart
      home: const ExpenseHomePage(), 
    );
  }
}