import '../services/generic_crud.dart';

// --- ĐỐI TƯỢNG 1: Giao dịch chi tiêu ---
class FinancialTransaction implements Identifiable {
  @override
  final String id;
  final String title;
  final double amount; // Kiểu dữ liệu số thực
  final String category;

  FinancialTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
  });

  // Phương thức hoạt động: Trả về số tiền thực tế tác động vào ví (Ví dụ: chi tiêu là số âm)
  double getImpactAmount() {
    return -amount; 
  }
}

// --- ĐỐI TƯỢNG 2: Mục tiêu tiết kiệm ---
class SavingGoal implements Identifiable {
  @override
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline; // Kiểu dữ liệu ngày tháng
  final DateTime createdAt;
  final DateTime updatedAt;

  SavingGoal({
    required this.id,
    required this.name,
    required double currentAmount,
    required this.targetAmount,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
  }) : this.currentAmount = currentAmount < 0.0 ? 0.0 : currentAmount;

  // Phương thức hoạt động: Tính toán % tiến độ hoàn thành mục tiêu
  double calculateProgress() {
    if (targetAmount <= 0) return 0.0;
    double progress = currentAmount / targetAmount;
    return progress > 1.0 ? 1.0 : progress;
  }

  // Phương thức hoạt động trả về kết quả dạng Chuỗi (String): Trạng thái mục tiêu
  String getGoalStatus() {
    if (currentAmount >= targetAmount) return "🎉 Đã đạt mục tiêu!";
    final daysLeft = deadline.difference(DateTime.now()).inDays;
    return daysLeft > 0 ? "Còn $daysLeft ngày để cố gắng" : "⚠️ Đã quá hạn";
  }

  // Kiểm tra mục tiêu có đang hoạt động trong tháng và năm được chọn không
  bool isActiveIn(int month, int year) {
    final selectedValue = year * 12 + month;
    final createdValue = createdAt.year * 12 + createdAt.month;
    final deadlineValue = deadline.year * 12 + deadline.month;
    return createdValue <= selectedValue && selectedValue <= deadlineValue;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': deadline.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SavingGoal.fromMap(Map<String, dynamic> map) {
    return SavingGoal(
      id: map['id'] as String,
      name: (map['name'] ?? map['goalName'] ?? '') as String,
      targetAmount: (map['targetAmount'] as num).toDouble(),
      currentAmount: (map['currentAmount'] as num).toDouble(),
      deadline: DateTime.parse(map['deadline'] as String),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  SavingGoal copyWith({
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavingGoal(
      id: this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}