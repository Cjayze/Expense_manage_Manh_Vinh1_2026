import 'base_entity.dart';

class ExpenseRecord extends BaseEntity {
  final String title;
  final String category;
  final double amount;
  final DateTime date;

  const ExpenseRecord({
    required super.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
  });

  double amountWithTax(double taxRate) {
    return amount * (1 + taxRate);
  }
}
