import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction.dart';
import '../models/categories.dart';
import 'auth_service.dart';

class DatabaseService {
  static const String _boxName = 'transactions_box';

  static Box<TransactionModel> getBox() {
    return Hive.box<TransactionModel>(_boxName);
  }

  static List<TransactionModel> getFilteredTransactions({
    required int month,
    required int year,
  }) {
    final box = getBox();
    return box.values
        .where(
          (tx) =>
              tx.dateTime.month == month &&
              tx.dateTime.year == year,
        )
        .toList()
      ..sort(
        (a, b) => b.dateTime.compareTo(a.dateTime),
      );
  }

  static Map<String, double> getCategoryBudgets() {
    final box = Hive.box('settings');
    final Map<String, double> budgets = {};
    for (final category in expenseCategories) {
      final key = 'budget_${category.name}';
      final limit = box.get(key);
      if (limit != null && limit is num && limit > 0) {
        budgets[category.name] = limit.toDouble();
      }
    }
    return budgets;
  }

  static Future<void> setCategoryBudget(String categoryName, double limit) async {
    final box = Hive.box('settings');
    final key = 'budget_$categoryName';
    if (limit <= 0) {
      await box.delete(key);
    } else {
      await box.put(key, limit);
    }

    if (AuthService.uid != null) {
      try {
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(AuthService.uid);
        await docRef.set({
          'budgets': {
            categoryName: limit,
          }
        }, SetOptions(merge: true));
      } catch (e) {
        print('Firestore budget write error: $e');
      }
    }
  }

  static Map<String, dynamic> getMonthSummary({
    required List<TransactionModel> transactions,
  }) {
    double totalIncome = 0;
    double totalExpense = 0;

    // Tính toán chi tiêu theo từng danh mục
    final Map<String, double> categoryExpenses = {};
    for (final tx in transactions) {
      if (tx.type == 'Thu nhập') {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;
        categoryExpenses[tx.categoryName] = (categoryExpenses[tx.categoryName] ?? 0.0) + tx.amount;
      }
    }

    final balance = totalIncome - totalExpense;
    final savingRate = totalIncome <= 0
        ? 0.0
        : (balance / totalIncome).clamp(0.0, 1.0);

    final categoryBudgets = getCategoryBudgets();
    double totalBudgetLimit = 0.0;
    int exceededCount = 0;
    double remainingBudgetsTotal = 0.0;

    categoryBudgets.forEach((categoryName, limit) {
      totalBudgetLimit += limit;
      final spent = categoryExpenses[categoryName] ?? 0.0;
      if (spent > limit) {
        exceededCount++;
      } else {
        remainingBudgetsTotal += (limit - spent);
      }
    });

    String insightMessage;
    if (totalIncome == 0 && totalExpense == 0) {
      insightMessage = 'Bạn chưa có dữ liệu trong tháng này. Hãy thêm giao dịch đầu tiên.';
    } else if (exceededCount > 0) {
      insightMessage = 'Cảnh báo: Có $exceededCount danh mục chi tiêu đã vượt quá ngân sách!';
    } else if (balance < 0) {
      insightMessage = 'Chi tiêu đang vượt thu nhập. Bạn nên kiểm soát lại các khoản chi.';
    } else if (totalIncome > 0 && totalExpense / totalIncome > 0.8) {
      insightMessage = 'Bạn đang dùng hơn 80% thu nhập. Hãy cân nhắc giảm chi tiêu.';
    } else {
      insightMessage = 'Bạn vẫn đang kiểm soát tốt dòng tiền trong tháng này.';
    }

    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'balance': balance,
      'savingRate': savingRate,
      'insightMessage': insightMessage,
      'budgetLimit': totalBudgetLimit,
      'remainingBudget': remainingBudgetsTotal,
      'exceededCount': exceededCount,
      'hasBudgets': categoryBudgets.isNotEmpty,
      'categoryExpenses': categoryExpenses,
    };
  }

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(
        TransactionModelAdapter(),
      );
    }

    await Hive.openBox<TransactionModel>(
      _boxName,
    );
  }

  static Future<void> addTransaction(
  TransactionModel transaction,
) async {
  try {
    print("UID hien tai: ${AuthService.uid}");
    print("Email: ${AuthService.currentEmail}");

    final box = getBox();

    await box.put(transaction.id, transaction);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService.uid)
        .collection('transactions')
        .doc(transaction.id)
        .set({
      'id': transaction.id,
      'type': transaction.type,
      'categoryName': transaction.categoryName,
      'categoryIconCode': transaction.categoryIconCode,
      'categoryColorValue': transaction.categoryColorValue,
      'amount': transaction.amount,
      'note': transaction.note,
      'dateTime': transaction.dateTime.toIso8601String(),
    });

    print("ĐÃ LƯU FIRESTORE THÀNH CÔNG");
  } catch (e) {
    print("LỖI FIRESTORE:");
    print(e);
  }
}
  static Future<void> updateTransaction(
  TransactionModel transaction,
) async {
  final box = getBox();

  await box.put(
    transaction.id,
    transaction,
  );

  await FirebaseFirestore.instance
      .collection('users')
      .doc(AuthService.uid)
      .collection('transactions')
      .doc(transaction.id)
      .set({
    'id': transaction.id,
    'type': transaction.type,
    'categoryName': transaction.categoryName,
    'categoryIconCode': transaction.categoryIconCode,
    'categoryColorValue': transaction.categoryColorValue,
    'amount': transaction.amount,
    'note': transaction.note,
    'dateTime':
        transaction.dateTime.toIso8601String(),
  });
}

  static Future<void> deleteTransaction(
    String id,
  ) async {
    final box = getBox();

    await box.delete(id);

    if (AuthService.uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService.uid)
        .collection('transactions')
        .doc(id)
        .delete();
  }

  static Future<void> syncFromFirebase()
      async {
    if (AuthService.uid == null) return;

    try {
      // 1. Sync Transactions
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(AuthService.uid)
              .collection('transactions')
              .get();

      final box = getBox();

      await box.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();

        final model = TransactionModel(
          id: data['id'],
          type: data['type'],
          categoryName:
              data['categoryName'],
          categoryIconCode:
              data['categoryIconCode'],
          categoryColorValue:
              data['categoryColorValue'],
          amount:
              (data['amount'] as num)
                  .toDouble(),
          note: data['note'],
          dateTime: DateTime.parse(
            data['dateTime'],
          ),
        );

        await box.put(
          model.id,
          model,
        );
      }

      // 2. Sync Budgets
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(AuthService.uid)
              .get();

      final settingsBox = Hive.box('settings');
      for (final category in expenseCategories) {
        await settingsBox.delete('budget_${category.name}');
      }

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null && userData.containsKey('budgets')) {
          final budgetsMap = userData['budgets'];
          if (budgetsMap is Map) {
            budgetsMap.forEach((key, value) {
              final limit = (value as num?)?.toDouble() ?? 0.0;
              if (limit > 0) {
                settingsBox.put('budget_$key', limit);
              }
            });
          }
        }
      }
    } catch (e) {
      print(
        'Firebase Sync Error: $e',
      );
    }
  }
}