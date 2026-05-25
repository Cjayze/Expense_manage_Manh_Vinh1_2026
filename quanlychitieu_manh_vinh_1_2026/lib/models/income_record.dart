import 'base_entity.dart';

class IncomeRecord extends BaseEntity {
  final String source;
  final int hours;
  final double rate;
  final bool isBonus;

  const IncomeRecord({
    required super.id,
    required this.source,
    required this.hours,
    required this.rate,
    required this.isBonus,
  });

  double gross() {
    final bonusMultiplier = isBonus ? 1.2 : 1.0;
    return hours * rate * bonusMultiplier;
  }
}
