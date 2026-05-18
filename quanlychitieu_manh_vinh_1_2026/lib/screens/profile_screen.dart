import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[700],
                child: const Icon(Icons.person_outline, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Đăng nhập', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Đăng nhập, thú vị hơn!', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
          ),
          child: const Row(
            children: [
              Icon(Icons.stars_outlined, color: Colors.amber, size: 28),
              SizedBox(width: 16),
              Expanded(
                child: Text('Thành viên Premium', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              ProfileMenuItem(icon: Icons.thumb_up_outlined, title: 'Giới thiệu cho bạn bè', iconColor: Colors.amberAccent),
              ProfileMenuItem(icon: Icons.speaker_notes_off_outlined, title: 'Chặn quảng cáo', iconColor: Colors.amberAccent),
              ProfileMenuItem(icon: Icons.settings_outlined, title: 'Cài đặt', iconColor: Colors.amberAccent),
              ProfileMenuItem(icon: Icons.apps_outlined, title: 'Ứng dụng của chúng tôi', iconColor: Colors.amberAccent),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  const ProfileMenuItem({super.key, required this.icon, required this.title, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}