import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'chart_screen.dart';
import 'report_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    ChartScreen(),
    ReportScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Trang chủ'),
              BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: 'Biểu đồ'),
              BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Báo cáo'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Tôi'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: const Color(0xFFFFEB3B),
              elevation: 4.0,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.black, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}