import 'package:flutter/material.dart';
import 'simple_page.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'Transaction',
      subtitle: 'Danh sach giao dich',
      icon: Icons.receipt_long,
    );
  }
}
