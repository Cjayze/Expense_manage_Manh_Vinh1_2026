import 'package:flutter/material.dart';
import 'simple_page.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'Analytics',
      subtitle: 'Thong ke chi tieu',
      icon: Icons.analytics,
    );
  }
}
