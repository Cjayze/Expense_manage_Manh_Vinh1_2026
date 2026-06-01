import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Biến quản lý trạng thái giao diện Sáng/Tối
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // KHỐI 1: HỒ SƠ TÀI KHOẢN
          const Text(
            'Hồ sơ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                'Tài khoản Google',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'user.example@gmail.com', // Bạn có thể thay bằng biến lấy từ AuthService sau này
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Icon(Icons.verified, color: Colors.green, size: 20),
            ),
          ),
          
          const SizedBox(height: 24),

          // KHỐI 2: GIAO DIỆN SÁNG & TỐI
          const Text(
            'Giao diện',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              activeColor: Colors.amber,
              secondary: Icon(
                _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: _isDarkMode ? Colors.orange : Colors.blue,
              ),
              title: const Text('Chế độ tối (Dark Mode)'),
              subtitle: Text(_isDarkMode ? 'Đang bật' : 'Đang tắt'),
              value: _isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  _isDarkMode = value;
                  // TODO: Thêm logic thay đổi Theme của app (ví dụ sử dụng Provider, Bloc hoặc Hive để lưu trạng thái)
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}