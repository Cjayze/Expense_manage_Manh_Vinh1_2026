import '../models/transaction.dart';
import 'database_service.dart' as db;

class ReportService {
  static List<TransactionModel> getTransactionsByMonth(
      int month,
      int year) {
    return db.DatabaseService.getBox()
        .values
        .where(
          (tx) =>
              tx.dateTime.month == month &&
              tx.dateTime.year == year,
        )
        .toList();
  }

  static double getTotalIncome(
      int month,
      int year) {
    return getTransactionsByMonth(month, year)
        .where((tx) => tx.type == "Thu nhập")
        .fold(
          0,
          (sum, tx) => sum + tx.amount,
        );
  }

  static double getTotalExpense(
      int month,
      int year) {
    return getTransactionsByMonth(month, year)
        .where((tx) => tx.type == "Chi tiêu")
        .fold(
          0,
          (sum, tx) => sum + tx.amount,
        );
  }

  static double getBalance(
      int month,
      int year) {
    return getTotalIncome(month, year) -
        getTotalExpense(month, year);
  }

  static Map<String, double> getExpenseByCategory(
      int month,
      int year) {
    final result = <String, double>{};

    final expenses = getTransactionsByMonth(
      month,
      year,
    ).where(
      (tx) => tx.type == "Chi tiêu",
    );

    for (final tx in expenses) {
      result.update(
        tx.categoryName,
        (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }

    return result;
  }

  static String getTopExpenseCategory(
      int month,
      int year) {
    final data =
        getExpenseByCategory(month, year);

    if (data.isEmpty) return "Không có";

    return data.entries
        .reduce(
          (a, b) =>
              a.value > b.value ? a : b,
        )
        .key;
  }

  static double getLargestExpense(
      int month,
      int year) {
    final expenses = getTransactionsByMonth(
      month,
      year,
    ).where(
      (tx) => tx.type == "Chi tiêu",
    );

    if (expenses.isEmpty) return 0;

    return expenses
        .map((e) => e.amount)
        .reduce(
          (a, b) => a > b ? a : b,
        );
  }
}