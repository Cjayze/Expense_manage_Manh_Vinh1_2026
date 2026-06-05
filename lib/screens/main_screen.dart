import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'chart_screen.dart';
import 'report_screen.dart';
import 'profile_screen.dart';
import 'add_transaction_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
  const HomeScreen(),
  const ChartScreen(),
  const ReportScreen(),
  const ProfileScreen(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
        },
        backgroundColor: const Color(0xFFFFEB3B),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1E1E1E),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.receipt_long, "Trang chủ", 0),
              _buildNavItem(Icons.pie_chart_outline, "Biểu đồ", 1),
              const SizedBox(width: 40), 
              _buildNavItem(Icons.article_outlined, "Báo cáo", 2),
              _buildNavItem(Icons.person_outline, "Tôi", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFFFFEB3B) : Colors.grey, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? const Color(0xFFFFEB3B) : Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}