import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: AuthService.isLoggedIn,
          builder: (context, loggedIn, _) {
            return ListView(
              children: [
                InkWell(
                  onTap: () {
                    if (!loggedIn) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    child: Row(
                      children: [
                        Container(
                          width: 65, height: 65,
                          decoration: BoxDecoration(
                            color: loggedIn ? Colors.amber : const Color(0xFF555555),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            loggedIn ? Icons.face : Icons.person, 
                            size: 40, 
                            color: loggedIn ? Colors.black : Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AuthService.currentUsername,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              AuthService.currentEmail,
                              style: TextStyle(color: Colors.grey[500], fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildProfileMenuItem(context, Icons.workspace_premium, Colors.amber, 'Thành viên Premium'),
                _buildProfileMenuItem(context, Icons.thumb_up_outlined, Colors.amber, 'Giới thiệu cho bạn bè'),
                _buildProfileMenuItem(context, Icons.block, Colors.amber, 'Chặn quảng cáo'),
                _buildProfileMenuItem(context, Icons.hexagon_outlined, Colors.amber, 'Cài đặt', isSettings: true),
                _buildProfileMenuItem(context, Icons.phone_android, Colors.amber, 'Ứng dụng của chúng tôi'),

                if (loggedIn) ...[
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C1614),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      label: const Text('Đăng xuất tài khoản', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        await AuthService.logout();
                      },
                    ),
                  )
                ]
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(BuildContext context, IconData icon, Color iconColor, String title, {bool isSettings = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 22),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: () {
          if (isSettings) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
          }
        },
      ),
    );
  }
}