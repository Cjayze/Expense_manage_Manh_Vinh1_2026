import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(AuthService.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();

        final avatarPath = data?['avatarPath'];
        final avatarUrl = data?['avatarUrl'];

        ImageProvider? image;

        if (avatarUrl != null &&
            avatarUrl.toString().isNotEmpty) {
          image = NetworkImage(avatarUrl);
        } else if (avatarPath != null &&
            avatarPath.toString().isNotEmpty) {
          image = AssetImage(avatarPath);
        }

        return Padding(
          padding: const EdgeInsets.only(
            right: 12,
          ),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: image,
            child: image == null
                ? const Icon(
                    Icons.person,
                    size: 18,
                  )
                : null,
          ),
        );
      },
    );
  }
}