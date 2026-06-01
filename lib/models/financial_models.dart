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
  final String goalName;
  final double currentAmount;
  final double targetAmount;
  final DateTime deadline; // Kiểu dữ liệu ngày tháng

  SavingGoal({
    required this.id,
    required this.goalName,
    required this.currentAmount,
    required this.targetAmount,
    required this.deadline,
  });

  // Phương thức hoạt động: Tính toán % tiến độ hoàn thành mục tiêu
  double calculateProgress() {
    if (targetAmount == 0) return 0.0;
    double progress = currentAmount / targetAmount;
    return progress > 1.0 ? 1.0 : progress;
  }

  // Phương thức hoạt động trả về kết quả dạng Chuỗi (String): Trạng thái mục tiêu
  String getGoalStatus() {
    if (currentAmount >= targetAmount) return "🎉 Đã đạt mục tiêu!";
    final daysLeft = deadline.difference(DateTime.now()).inDays;
    return daysLeft > 0 ? "Còn $daysLeft ngày để cố gắng" : "⚠️ Đã quá hạn";
  }
}