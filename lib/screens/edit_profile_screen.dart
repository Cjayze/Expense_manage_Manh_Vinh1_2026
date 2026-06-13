import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  String? avatarPath;
  String? avatarUrl;

  final TextEditingController
      displayNameController =
      TextEditingController();

  final List<String> defaultAvatars = [
    'assets/avatars/avatar_1.jpg',
    'assets/avatars/avatar_2.jpg',
    'assets/avatars/avatar_3.jpg',
    'assets/avatars/avatar_4.jpg',
    'assets/avatars/avatar_5.jpg',
    'assets/avatars/avatar_6.jpg',
    'assets/avatars/avatar_7.jpg',
    'assets/avatars/avatar_8.jpg',
    'assets/avatars/avatar_9.jpg',
    'assets/avatars/avatar_10.jpg',
  ];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(AuthService.uid)
            .get();

    if (!doc.exists) return;

    final data = doc.data()!;

    setState(() {
      displayNameController.text =
          data['displayName'] ?? '';

      avatarPath = data['avatarPath'];
      avatarUrl = data['avatarUrl'];
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final file = File(image.path);

    final ref = FirebaseStorage.instance
        .ref()
        .child('avatars')
        .child('${AuthService.uid}.jpg');

    await ref.putFile(file);

    final url = await ref.getDownloadURL();

    setState(() {
      avatarUrl = url;
      avatarPath = null;
    });
  }

  Future<void> chooseDefaultAvatar() async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Chọn avatar mặc định",
          ),
          content: SizedBox(
            width: 320,
            height: 300,
            child: GridView.builder(
              itemCount:
                  defaultAvatars.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (
                context,
                index,
              ) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      avatarPath =
                          defaultAvatars[index];
                      avatarUrl = null;
                    });

                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundImage:
                        AssetImage(
                      defaultAvatars[index],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> saveProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService.uid)
        .set({
      'displayName':
          displayNameController.text,
      'avatarPath': avatarPath,
      'avatarUrl': avatarUrl,
      'email':
          AuthService.currentEmail,
    }, SetOptions(merge: true));

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text("Cập nhật hồ sơ thành công"),
      ),
    );

    Navigator.pop(context);
  }

  void showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.image),
                title: const Text(
                  "Tải ảnh từ thiết bị",
                ),
                onTap: () {
                  Navigator.pop(
                    context,
                  );
                  pickImage();
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.face),
                title: const Text(
                  "Chọn avatar mặc định",
                ),
                onTap: () {
                  Navigator.pop(
                    context,
                  );
                  chooseDefaultAvatar();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (avatarUrl != null &&
        avatarUrl!.isNotEmpty) {
      imageProvider =
          NetworkImage(avatarUrl!);
    } else if (avatarPath != null &&
        avatarPath!.isNotEmpty) {
      imageProvider =
          AssetImage(avatarPath!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chỉnh sửa hồ sơ",
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap:
                  showAvatarOptions,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        imageProvider,
                    child:
                        imageProvider ==
                                null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                              )
                            : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding:
                          const EdgeInsets.all(
                        6,
                      ),
                      decoration:
                          const BoxDecoration(
                        color:
                            Colors.amber,
                        shape:
                            BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color:
                            Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            TextField(
              controller:
                  displayNameController,
              decoration:
                  const InputDecoration(
                border:
                    OutlineInputBorder(),
                labelText:
                    "Tên hiển thị",
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    saveProfile,
                child: const Text(
                  "Lưu thay đổi",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}