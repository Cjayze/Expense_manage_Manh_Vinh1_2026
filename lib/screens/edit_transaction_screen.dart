import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/database_service.dart' as db;

class EditTransactionScreen extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState
    extends State<EditTransactionScreen> {
  late TextEditingController amountController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();

    amountController = TextEditingController(
      text: widget.transaction.amount.toString(),
    );

    noteController = TextEditingController(
      text: widget.transaction.note,
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final amount =
        double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng nhập số tiền hợp lệ',
          ),
        ),
      );
      return;
    }

    final updated = TransactionModel(
      id: widget.transaction.id,
      type: widget.transaction.type,
      categoryName:
          widget.transaction.categoryName,
      categoryIconCode:
          widget.transaction.categoryIconCode,
      categoryColorValue:
          widget.transaction.categoryColorValue,
      amount: amount,
      note: noteController.text,
      dateTime: widget.transaction.dateTime,
    );

    await db.DatabaseService.updateTransaction(
      updated,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sửa giao dịch",
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller:
                  amountController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText: "Số tiền",
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                border:
                    OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller:
                  noteController,
              decoration:
                  const InputDecoration(
                labelText: "Ghi chú",
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                border:
                    OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: save,
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
