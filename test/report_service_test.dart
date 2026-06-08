import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Report Service Test', () {
    test('Income calculation', () {
      double income1 = 1000000;
      double income2 = 500000;

      double total = income1 + income2;

      expect(total, 1500000);
    });

    test('Expense calculation', () {
      double expense1 = 300000;
      double expense2 = 200000;

      double total = expense1 + expense2;

      expect(total, 500000);
    });

    test('Balance calculation', () {
      double income = 2000000;
      double expense = 800000;

      double balance = income - expense;

      expect(balance, 1200000);
    });
  });
}