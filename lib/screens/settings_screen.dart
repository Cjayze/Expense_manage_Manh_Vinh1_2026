import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable:
          ThemeService.isDarkMode,
      builder: (
        context,
        isDarkMode,
        _,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cài đặt'),
            centerTitle: true,
          ),
          body: ListView(
            padding:
                const EdgeInsets.all(16),
            children: [
              const Text(
                'Hồ sơ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Card(
                elevation: 2,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading:
                          const CircleAvatar(
                        backgroundColor:
                            Colors
                                .blueAccent,
                        child: Icon(
                          Icons.person,
                          color:
                              Colors.white,
                        ),
                      ),
                      title: const Text(
                        'Tài khoản hiện tại',
                        style: TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                      subtitle: Text(
                        AuthService
                                .currentEmail
                                .isEmpty
                            ? 'Chưa đăng nhập'
                            : AuthService
                                .currentEmail,
                        style:
                            const TextStyle(
                          color:
                              Colors.grey,
                        ),
                      ),
                      trailing: Icon(
                        AuthService
                                .isLoggedIn
                                .value
                            ? Icons.verified
                            : Icons
                                .warning_amber_rounded,
                        color: AuthService
                                .isLoggedIn
                                .value
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),

                    const Divider(
                      height: 1,
                    ),

                    ListTile(
                      leading: const Icon(
                        Icons.edit,
                      ),
                      title: const Text(
                        'Chỉnh sửa hồ sơ',
                      ),
                      trailing:
                          const Icon(
                        Icons
                            .chevron_right,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              const Text(
                'Giao diện',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Card(
                elevation: 2,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: SwitchListTile(
                  activeColor:
                      Colors.amber,
                  secondary: Icon(
                    isDarkMode
                        ? Icons.dark_mode
                        : Icons
                            .light_mode,
                    color: isDarkMode
                        ? Colors.orange
                        : Colors.blue,
                  ),
                  title: const Text(
                    'Dark Mode',
                  ),
                  subtitle: Text(
                    isDarkMode
                        ? 'Đang bật'
                        : 'Đang tắt',
                  ),
                  value: isDarkMode,
                  onChanged:
                      (value) async {
                    await ThemeService
                        .setDarkMode(
                      value,
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              const Text(
                'Thông tin ứng dụng',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Card(
                elevation: 2,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: const Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons
                            .account_balance_wallet,
                      ),
                      title: Text(
                        'Sổ Thu Chi',
                      ),
                      subtitle: Text(
                        'Version 1.0.0',
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.code),
                      title: Text(
                        'Flutter + Firebase',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}