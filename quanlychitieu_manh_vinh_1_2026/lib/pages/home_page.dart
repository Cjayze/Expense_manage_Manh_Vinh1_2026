import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/common_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference<Map<String, dynamic>> _expenses =
      FirebaseFirestore.instance.collection('expenses');

  String _formatTimestamp(dynamic value) {
    if (value is Timestamp) {
      final date = value.toDate();
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
    return 'Chua co ngay';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CommonHeader(title: 'Home'),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _expenses.orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Loi tai du lieu: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final documents = snapshot.data?.docs ?? [];
              final totalExpense = documents.fold<double>(
                0,
                (sum, document) {
                  final amount = (document.data()['amount'] as num?)?.toDouble() ?? 0;
                  return sum + amount;
                },
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tong chi tieu: ${totalExpense.toStringAsFixed(0)}'),
                      const SizedBox(height: 20),
                      Text(
                        'Danh sach chi tieu',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (documents.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text('Chua co giao dich nao. Sang tab Add de them moi.'),
                          ),
                        )
                      else
                        Column(
                          children: [
                            for (final document in documents)
                              Card(
                                child: ListTile(
                                  title: Text(document.data()['title'] as String? ?? 'Khong ro ten'),
                                  subtitle: Text(
                                    '${document.data()['category'] as String? ?? 'Khong danh muc'} | ${_formatTimestamp(document.data()['createdAt'])}',
                                  ),
                                  trailing: Text(
                                    'Tien: ${(document.data()['amount'] as num?)?.toDouble().toStringAsFixed(0) ?? '0'}',
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
