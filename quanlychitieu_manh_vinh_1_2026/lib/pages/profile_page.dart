import 'package:flutter/material.dart';
import 'simple_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'Profile',
      subtitle: 'Thong tin tai khoan',
      icon: Icons.person,
    );
  }
}
