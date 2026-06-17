import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quanlychitieu_manh_vinh_1_2026/services/database_service.dart';
import 'package:quanlychitieu_manh_vinh_1_2026/models/transaction.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);
    await Hive.openBox('settings');
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('DatabaseService Budget Operations Test', () {
    test('Set and Get Category Budgets', () async {
      // Ban đầu, danh sách ngân sách phải trống
      var budgets = DatabaseService.getCategoryBudgets(month: 6, year: 2026);
      expect(budgets.isEmpty, true);

      // Thiết lập ngân sách cho "Đồ ăn"
      await DatabaseService.setCategoryBudget(
        categoryName: 'Đồ ăn',
        limit: 2000000.0,
        month: 6,
        year: 2026,
      );

      // Xác minh ngân sách được thiết lập thành công
      budgets = DatabaseService.getCategoryBudgets(month: 6, year: 2026);
      expect(budgets.length, 1);
      expect(budgets['Đồ ăn'], 2000000.0);

      // Thiết lập ngân sách cho "Mua sắm"
      await DatabaseService.setCategoryBudget(
        categoryName: 'Mua sắm',
        limit: 5000000.0,
        month: 6,
        year: 2026,
      );

      // Xác minh cả hai ngân sách đều tồn tại
      budgets = DatabaseService.getCategoryBudgets(month: 6, year: 2026);
      expect(budgets.length, 2);
      expect(budgets['Đồ ăn'], 2000000.0);
      expect(budgets['Mua sắm'], 5000000.0);

      // Cập nhật ngân sách cho "Đồ ăn"
      await DatabaseService.setCategoryBudget(
        categoryName: 'Đồ ăn',
        limit: 1500000.0,
        month: 6,
        year: 2026,
      );
      budgets = DatabaseService.getCategoryBudgets(month: 6, year: 2026);
      expect(budgets['Đồ ăn'], 1500000.0);

      // Xóa ngân sách (đặt về 0) của "Mua sắm"
      await DatabaseService.setCategoryBudget(
        categoryName: 'Mua sắm',
        limit: 0.0,
        month: 6,
        year: 2026,
      );
      budgets = DatabaseService.getCategoryBudgets(month: 6, year: 2026);
      expect(budgets.length, 1);
      expect(budgets.containsKey('Mua sắm'), false);
    });

    test('Budgets are persisted after closing and reopening settings box', () async {
      await DatabaseService.setCategoryBudget(
        categoryName: 'Đồ ăn',
        limit: 1500000.0,
        month: 6,
        year: 2026,
      );
      await DatabaseService.setCategoryBudget(
        categoryName: 'Mua sắm',
        limit: 3000000.0,
        month: 6,
        year: 2026,
      );

      // Đóng box settings
      await Hive.box('settings').close();

      // Mở lại box settings
      await Hive.openBox('settings');

      // Xác minh các ngân sách vẫn tồn tại và có giá trị chính xác
      final budgets = DatabaseService.getCategoryBudgets(month: 6, year: 2026);
      expect(budgets['Đồ ăn'], 1500000.0);
      expect(budgets['Mua sắm'], 3000000.0);
    });

    test('Budgets are isolated by month and year', () async {
      // Đặt ngân sách tháng 06/2026
      await DatabaseService.setCategoryBudget(
        categoryName: 'Đồ ăn',
        limit: 1000000.0,
        month: 6,
        year: 2026,
      );

      // Đặt ngân sách tháng 07/2026
      await DatabaseService.setCategoryBudget(
        categoryName: 'Đồ ăn',
        limit: 2000000.0,
        month: 7,
        year: 2026,
      );

      // Xác minh ngân sách tháng 06/2026
      var budgetsJune = DatabaseService.getCategoryBudgets(month: 6, year: 2026);
      expect(budgetsJune['Đồ ăn'], 1000000.0);

      // Xác minh ngân sách tháng 07/2026
      var budgetsJuly = DatabaseService.getCategoryBudgets(month: 7, year: 2026);
      expect(budgetsJuly['Đồ ăn'], 2000000.0);

      // Xác minh ngân sách tháng 08/2026 (chưa đặt)
      var budgetsAugust = DatabaseService.getCategoryBudgets(month: 8, year: 2026);
      expect(budgetsAugust.isEmpty, true);
    });

    test('getMonthSummary calculates correct totals and budget status', () async {
      // Thiết lập ngân sách: "Đồ ăn" -> 1.000.000, "Mua sắm" -> 2.000.000
      await DatabaseService.setCategoryBudget(
        categoryName: 'Đồ ăn',
        limit: 1000000.0,
        month: 6,
        year: 2026,
      );
      await DatabaseService.setCategoryBudget(
        categoryName: 'Mua sắm',
        limit: 2000000.0,
        month: 6,
        year: 2026,
      );

      // Tạo một số giao dịch giả lập trong bộ nhớ
      final t1 = TransactionModel(
        id: '1',
        type: 'Chi tiêu',
        categoryName: 'Đồ ăn',
        categoryIconCode: 0,
        categoryColorValue: 0,
        amount: 800000.0, // trong hạn mức ngân sách
        note: 'Ăn tối',
        dateTime: DateTime(2026, 6, 15),
      );

      final t2 = TransactionModel(
        id: '2',
        type: 'Chi tiêu',
        categoryName: 'Mua sắm',
        categoryIconCode: 0,
        categoryColorValue: 0,
        amount: 2500000.0, // vượt quá hạn mức ngân sách
        note: 'Mua sắm đồ dùng',
        dateTime: DateTime(2026, 6, 16),
      );

      final t3 = TransactionModel(
        id: '3',
        type: 'Thu nhập',
        categoryName: 'Lương',
        categoryIconCode: 0,
        categoryColorValue: 0,
        amount: 5000000.0,
        note: 'Lương tháng 6',
        dateTime: DateTime(2026, 6, 17),
      );

      final summary = DatabaseService.getMonthSummary(
        transactions: [t1, t2, t3],
        month: 6,
        year: 2026,
      );

      expect(summary['totalIncome'], 5000000.0);
      expect(summary['totalExpense'], 3300000.0);
      expect(summary['balance'], 1700000.0);
      expect(summary['savingRate'], closeTo(1700000.0 / 5000000.0, 0.001));

      // Số lượng danh mục vượt hạn mức phải là 1 (chỉ có "Mua sắm" vượt)
      expect(summary['exceededCount'], 1);

      // Tổng ngân sách còn lại phải là (1.000.000 - 800.000) = 200.000
      expect(summary['remainingBudget'], 200000.0);

      expect(summary['hasBudgets'], true);
    });
  });
}