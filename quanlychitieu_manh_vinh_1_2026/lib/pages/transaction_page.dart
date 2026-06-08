import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/common_header.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final CollectionReference<Map<String, dynamic>> _expenses =
      FirebaseFirestore.instance.collection('expenses');

  String _formatTimestamp(dynamic value) {
    if (value is Timestamp) {
      final date = value.toDate();
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
    return 'Chua co ngay';
  }

  Future<void> _editExpense(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) async {
    final data = document.data() ?? const <String, dynamic>{};
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: data['title'] as String? ?? '');
    final categoryController = TextEditingController(text: data['category'] as String? ?? '');
    final amountController = TextEditingController(text: data['amount']?.toString() ?? '');
    final noteController = TextEditingController(text: data['note'] as String? ?? '');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cap nhat giao dich'),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Ten giao dich'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nhap ten giao dich';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Danh muc'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nhap danh muc';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'So tien'),
                      validator: (value) {
                        final amount = double.tryParse(value ?? '');
                        if (amount == null || amount <= 0) {
                          return 'Nhap so tien hop le';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: noteController,
                      decoration: const InputDecoration(labelText: 'Ghi chu'),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Huy'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                try {
                  await _expenses.doc(document.id).update({
                    'title': titleController.text.trim(),
                    'category': categoryController.text.trim(),
                    'amount': double.parse(amountController.text.trim()),
                    'note': noteController.text.trim(),
                    'updatedAt': FieldValue.serverTimestamp(),
                  });

                  if (mounted) {
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Da cap nhat giao dich')),
                    );
                  }
                } catch (error) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Loi Firebase: $error')),
                    );
                  }
                }
              },
              child: const Text('Luu'),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    categoryController.dispose();
    amountController.dispose();
    noteController.dispose();
  }

  Future<void> _deleteExpense(String id) async {
    try {
      await _expenses.doc(id).delete();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Da xoa giao dich')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Khong the xoa: $error')),
      );
    }
  }

  Future<void> _confirmDelete(DocumentSnapshot<Map<String, dynamic>> document) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xoa giao dich'),
          content: const Text('Ban co chac muon xoa ban ghi nay khong?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Khong'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Xoa'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _deleteExpense(document.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CommonHeader(title: 'Transaction'),
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

              if (documents.isEmpty) {
                return const Center(
                  child: Text('Chua co giao dich nao. Sang tab Add de them moi.'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: documents.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final document = documents[index];
                  final data = document.data();
                  final title = data['title'] as String? ?? 'Khong ro ten';
                  final category = data['category'] as String? ?? 'Khong danh muc';
                  final note = data['note'] as String? ?? '';
                  final amount = (data['amount'] as num?)?.toDouble() ?? 0;

                  return Card(
                    child: ListTile(
                      onTap: () => _editExpense(document),
                      onLongPress: () => _confirmDelete(document),
                      title: Text(title),
                      subtitle: Text(
                        '$category | ${_formatTimestamp(data['createdAt'])}\n${note.isEmpty ? 'Khong co ghi chu' : note}',
                      ),
                      isThreeLine: true,
                      trailing: Text(
                        amount.toStringAsFixed(0),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
