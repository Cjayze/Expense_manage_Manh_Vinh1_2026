import 'package:flutter_test/flutter_test.dart';
import 'package:quanlychitieu_manh_vinh_1_2026/models/transaction.dart';

void main() {
  group('Transaction Model Test', () {
    test('Create transaction object', () {
      final transaction = TransactionModel(
        id: "1",
        type: "Chi tiêu",
        categoryName: "Ăn uống",
        categoryIconCode: 0xe57a,
        categoryColorValue: 0xFFFFC107,
        amount: 100000,
        note: "Ăn sáng",
        dateTime: DateTime.now(),
      );

      expect(
        transaction.amount,
        100000,
      );

      expect(
        transaction.type,
        "Chi tiêu",
      );
    });
  });
}