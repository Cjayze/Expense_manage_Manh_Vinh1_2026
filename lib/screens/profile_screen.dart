import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/transaction.dart' hide DatabaseService;
import 'login_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Tài khoản"),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: AuthService.isLoggedIn,
        builder: (context, loggedIn, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.amber,
                      child: Icon(
                        loggedIn ? Icons.person : Icons.person_outline,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AuthService.currentUsername,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AuthService.currentEmail,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _menuItem(
                context,
                icon: Icons.settings,
                title: "Cài đặt",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),

              _menuItem(
                context,
                icon: Icons.bar_chart,
                title: "Số giao dịch",
                subtitle:
                    "${DatabaseService.getBox().values.length} giao dịch",
              ),

              _menuItem(
                context,
                icon: Icons.delete_forever,
                title: "Xóa toàn bộ dữ liệu",
                iconColor: Colors.red,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Xác nhận"),
                      content: const Text(
                        "Bạn có chắc muốn xóa toàn bộ giao dịch?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, false),
                          child: const Text("Hủy"),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, true),
                          child: const Text("Xóa"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await DatabaseService.getBox().clear();
                  }
                },
              ),

              const SizedBox(height: 24),

              if (!loggedIn)
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text("Đăng nhập"),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(),
                      ),
                    );
                  },
                ),

              if (loggedIn)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text("Đăng xuất"),
                  onPressed: () async {
                    await AuthService.logout();
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color iconColor = Colors.amber,
    VoidCallback? onTap,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                style: const TextStyle(color: Colors.grey),
              ),
        trailing: onTap != null
            ? const Icon(Icons.chevron_right)
            : null,
        onTap: onTap,
      ),
    );
  }
}