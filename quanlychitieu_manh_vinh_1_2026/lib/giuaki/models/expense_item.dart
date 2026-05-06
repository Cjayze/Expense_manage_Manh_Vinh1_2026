class ExpenseItem{
  final String name;
  final double pricePerLb;
  final double quantity;
  final String emoji;

  const ExpenseItem({
    required this.name,
    required this.pricePerLb,
    required this.quantity,
    required this.emoji,
  });
  double get total => pricePerLb * quantity;
}