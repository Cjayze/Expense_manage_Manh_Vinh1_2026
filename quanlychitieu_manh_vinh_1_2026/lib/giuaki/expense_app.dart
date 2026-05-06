import 'package:flutter/material.dart';
import 'theme/colors.dart';
import 'pages/expense_page.dart';

class ExpenseTrackerApp extends StatelessWidget{
  const ExpenseTrackerApp({super.key});
  @override 
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Quản Lý Chi Tiêu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
        useMaterial3: true,
        fontFamily: 'Georgia',
      ),
      home: const ExpensePage(),
    );
  }
}