import 'package:flutter_test/flutter_test.dart';
import 'package:quanlychitieu_manh_vinh_1_2026/models/transaction.dart';

void main() {
  group('TransactionModel', () {
    test('can be instantiated and fields match', () {
      final now = DateTime.now();

      final tx = TransactionModel(
        id: 'tx1',
        type: 'Chi tiêu',
        categoryName: 'Ăn uống',
        categoryIconCode: 58834,
        categoryColorValue: 0xFF0000FF,
        amount: 123.45,
        note: 'Ghi chú',
        dateTime: now,
      );

      expect(tx.id, 'tx1');
      expect(tx.type, 'Chi tiêu');
      expect(tx.categoryName, 'Ăn uống');
      expect(tx.categoryIconCode, 58834);
      expect(tx.categoryColorValue, 0xFF0000FF);
      expect(tx.amount, 123.45);
      expect(tx.note, 'Ghi chú');
      expect(tx.dateTime, now);
    });

    test('toMap and fromMap convert correctly', () {
      final now = DateTime.now();

      final tx = TransactionModel(
        id: 'tx2',
        type: 'Thu nhập',
        categoryName: 'Lương',
        categoryIconCode: 58835,
        categoryColorValue: 0xFF00FF00,
        amount: 1000.0,
        note: '',
        dateTime: now,
      );

      final map = tx.toMap();

      expect(map['id'], 'tx2');
      expect(map['type'], 'Thu nhập');
      expect(map['categoryName'], 'Lương');
      expect(map['categoryIconCode'], 58835);
      expect(map['categoryColorValue'], 0xFF00FF00);
      expect((map['amount'] as num).toDouble(), 1000.0);
      expect(map['note'], '');
      expect(map['dateTime'], now.toIso8601String());

      final tx2 = TransactionModel.fromMap(map);

      expect(tx2.id, tx.id);
      expect(tx2.type, tx.type);
      expect(tx2.categoryName, tx.categoryName);
      expect(tx2.categoryIconCode, tx.categoryIconCode);
      expect(tx2.categoryColorValue, tx.categoryColorValue);
      expect(tx2.amount, tx.amount);
      expect(tx2.note, tx.note);
      expect(tx2.dateTime.toIso8601String(), tx.dateTime.toIso8601String());
    });
  });
}
