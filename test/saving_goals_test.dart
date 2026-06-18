import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quanlychitieu_manh_vinh_1_2026/services/database_service.dart';
import 'package:quanlychitieu_manh_vinh_1_2026/models/financial_models.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_goals_test');
    Hive.init(tempDir.path);
    await Hive.openBox('saving_goals_box');
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('Saving Goals Model & Operations Tests', () {
    test('SavingGoal construction and value clamping', () {
      final now = DateTime.now();

      final goal = SavingGoal(
        id: '1',
        name: 'Mua Laptop',
        currentAmount: 5000.0,
        targetAmount: 20000.0,
        deadline: now.add(const Duration(days: 10)),
        createdAt: now,
        updatedAt: now,
      );

      expect(goal.id, '1');
      expect(goal.name, 'Mua Laptop');
      expect(goal.currentAmount, 5000.0);
      expect(goal.targetAmount, 20000.0);
      expect(goal.calculateProgress(), 0.25);

      final negativeGoal = SavingGoal(
        id: '2',
        name: 'Negative Test',
        currentAmount: -1500.0,
        targetAmount: 10000.0,
        deadline: now.add(const Duration(days: 10)),
        createdAt: now,
        updatedAt: now,
      );

      expect(negativeGoal.currentAmount, 0.0);
    });

    test('Progress calculations and status edge cases', () {
      final now = DateTime.now();

      final overAchievedGoal = SavingGoal(
        id: '3',
        name: 'Over Achieved',
        currentAmount: 15000.0,
        targetAmount: 10000.0,
        deadline: now.add(const Duration(days: 10)),
        createdAt: now,
        updatedAt: now,
      );
      expect(overAchievedGoal.calculateProgress(), 1.0);
      expect(overAchievedGoal.getGoalStatus(), '🎉 Đã đạt mục tiêu!');

      final zeroTargetGoal = SavingGoal(
        id: '4',
        name: 'Zero Target',
        currentAmount: 1000.0,
        targetAmount: 0.0,
        deadline: now.add(const Duration(days: 10)),
        createdAt: now,
        updatedAt: now,
      );
      expect(zeroTargetGoal.calculateProgress(), 0.0);

      final negativeTargetGoal = SavingGoal(
        id: '5',
        name: 'Negative Target',
        currentAmount: 1000.0,
        targetAmount: -500.0,
        deadline: now.add(const Duration(days: 10)),
        createdAt: now,
        updatedAt: now,
      );
      expect(negativeTargetGoal.calculateProgress(), 0.0);

      final expiredGoal = SavingGoal(
        id: '6',
        name: 'Expired Goal',
        currentAmount: 5000.0,
        targetAmount: 10000.0,
        deadline: now.subtract(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now,
      );
      expect(expiredGoal.getGoalStatus(), '⚠️ Đã quá hạn');

      final futureGoal = SavingGoal(
        id: '7',
        name: 'Future Goal',
        currentAmount: 2000.0,
        targetAmount: 10000.0,
        deadline: now.add(const Duration(days: 5, hours: 2)),
        createdAt: now,
        updatedAt: now,
      );
      expect(futureGoal.getGoalStatus(), contains('Còn 5 ngày'));
    });

    test('SavingGoal isActiveIn time period active filtering', () {
      final now = DateTime(2026, 6, 15);
      final goal = SavingGoal(
        id: 'active_test',
        name: 'Laptop Fund',
        currentAmount: 1000.0,
        targetAmount: 10000.0,
        deadline: DateTime(2026, 12, 31), 
        createdAt: DateTime(2026, 6, 1), 
        updatedAt: now,
      );

      expect(goal.isActiveIn(6, 2026), true);

      expect(goal.isActiveIn(7, 2026), true);

      expect(goal.isActiveIn(12, 2026), true);

      expect(goal.isActiveIn(5, 2026), false);

      expect(goal.isActiveIn(1, 2027), false);

      expect(goal.isActiveIn(6, 2025), false);
    });

    test('SavingGoal copyWith method', () {
      final now = DateTime.now();
      final goal = SavingGoal(
        id: '8',
        name: 'Original',
        currentAmount: 1000.0,
        targetAmount: 10000.0,
        deadline: now.add(const Duration(days: 10)),
        createdAt: now,
        updatedAt: now,
      );

      final updatedGoal = goal.copyWith(
        name: 'Updated Name',
        currentAmount: 2000.0,
        updatedAt: now.add(const Duration(seconds: 1)),
      );

      expect(updatedGoal.id, '8'); 
      expect(updatedGoal.name, 'Updated Name');
      expect(updatedGoal.currentAmount, 2000.0);
      expect(updatedGoal.targetAmount, 10000.0);
      expect(updatedGoal.deadline, goal.deadline);
      expect(updatedGoal.createdAt, goal.createdAt);
      expect(updatedGoal.updatedAt.isAfter(goal.updatedAt), true);
    });

    test('DatabaseService Saving Goals CRUD Operations', () async {
      final now = DateTime.now();

      var goals = DatabaseService.getSavingGoals();
      expect(goals.isEmpty, true);

      final goal1 = SavingGoal(
        id: 'g1',
        name: 'Laptop',
        currentAmount: 0.0,
        targetAmount: 15000.0,
        deadline: now.add(const Duration(days: 30)),
        createdAt: now,
        updatedAt: now,
      );
      await DatabaseService.addOrUpdateSavingGoal(goal1);

      goals = DatabaseService.getSavingGoals();
      expect(goals.length, 1);
      expect(goals.first.name, 'Laptop');
      expect(goals.first.targetAmount, 15000.0);

      final updatedGoal = goal1.copyWith(
        currentAmount: 5000.0,
        updatedAt: now.add(const Duration(minutes: 5)),
      );
      await DatabaseService.addOrUpdateSavingGoal(updatedGoal);

      goals = DatabaseService.getSavingGoals();
      expect(goals.length, 1);
      expect(goals.first.currentAmount, 5000.0);

      await DatabaseService.deleteSavingGoal('g1');
      goals = DatabaseService.getSavingGoals();
      expect(goals.isEmpty, true);
    });
  });
}
