import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'chart_screen.dart';
import 'report_screen.dart';
import 'profile_screen.dart';
import 'qr_scanner_screen.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: theme.cardColor,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.receipt_long, "Trang chủ", 0),
              _buildNavItem(Icons.pie_chart_outline, "Biểu đồ", 1),
              _buildScanItem(),
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
    final theme = Theme.of(context);
    final color =
        isSelected ? const Color(0xFFFFEB3B) : theme.hintColor;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildScanItem() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QrScannerScreen()),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFFFEB3B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.qr_code_scanner, color: Colors.black, size: 22),
          ),
          const SizedBox(height: 2),
          const Text("Quét", style: TextStyle(color: Color(0xFFFFEB3B), fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
