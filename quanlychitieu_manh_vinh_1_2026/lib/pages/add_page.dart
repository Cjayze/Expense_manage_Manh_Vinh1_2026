import 'package:flutter/material.dart';
import 'simple_page.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'Add',
      subtitle: 'Them chi tieu / thu nhap',
      icon: Icons.add_circle_outline,
    );
  }
}
