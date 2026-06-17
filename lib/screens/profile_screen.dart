import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_profile_screen.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

class EditableAvatar extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const EditableAvatar({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: child,
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tài khoản"),
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
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    EditableAvatar(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const EditProfileScreen(),
                          ),
                        );
                      },
                      child: StreamBuilder<
                          DocumentSnapshot<
                              Map<String, dynamic>>>(
                        stream: FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(AuthService.uid ?? '')
                            .snapshots(),
                        builder: (
                          context,
                          snapshot,
                        ) {
                          final data =
                              snapshot.data?.data();

                          final avatarPath =
                              data?['avatarPath'];

                          final avatarUrl =
                              data?['avatarUrl'];

                          ImageProvider? image;

                          if (avatarUrl != null &&
                              avatarUrl
                                  .toString()
                                  .isNotEmpty) {
                            image = NetworkImage(
                              avatarUrl,
                            );
                          } else if (avatarPath !=
                                  null &&
                              avatarPath
                                  .toString()
                                  .isNotEmpty) {
                            image = AssetImage(
                              avatarPath,
                            );
                          }

                          return CircleAvatar(
                            radius: 35,
                            backgroundColor:
                                Colors.amber,
                            backgroundImage:
                                image,
                            child: image == null
                                ? const Icon(
                                    Icons.person,
                                    size: 40,
                                    color:
                                        Colors.black,
                                  )
                                : null,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: StreamBuilder<
                          DocumentSnapshot<
                              Map<String, dynamic>>>(
                        stream: FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(AuthService.uid ?? '')
                            .snapshots(),
                        builder: (
                          context,
                          snapshot,
                        ) {
                          final data =
                              snapshot.data?.data();

                          final displayName =
                              data?['displayName'] ??
                                  AuthService
                                      .currentUsername;

                          final email =
                              data?['email'] ??
                                  AuthService
                                      .currentEmail;

                          return Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                displayName,
                                style: TextStyle(
                                  color: theme
                                      .colorScheme
                                      .onSurface,
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                              Text(
                                email,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.grey,
                                ),
                              ),
                            ],
                          );
                        },
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
                      builder: (_) =>
                          const SettingsScreen(),
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
                  final confirm =
                      await showDialog<bool>(
                    context: context,
                    builder: (_) =>
                        AlertDialog(
                      title:
                          const Text("Xác nhận"),
                      content: const Text(
                        "Bạn có chắc muốn xóa toàn bộ giao dịch?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(
                                  context,
                                  false),
                          child:
                              const Text("Hủy"),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(
                                  context,
                                  true),
                          child:
                              const Text("Xóa"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await DatabaseService
                        .getBox()
                        .clear();
                  }
                },
              ),

              const SizedBox(height: 24),

              if (!loggedIn)
                ElevatedButton.icon(
                  icon:
                      const Icon(Icons.login),
                  label:
                      const Text("Đăng nhập"),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LoginScreen(),
                      ),
                    );
                  },
                ),

              if (loggedIn)
                ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red,
                  ),
                  icon:
                      const Icon(Icons.logout),
                  label:
                      const Text("Đăng xuất"),
                  onPressed: () async {
                    await AuthService
                        .logout();
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
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(title),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
        trailing: onTap != null
            ? const Icon(
                Icons.chevron_right,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}