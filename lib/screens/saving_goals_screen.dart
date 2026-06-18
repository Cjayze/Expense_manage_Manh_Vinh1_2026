import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/financial_models.dart';
import '../services/database_service.dart';
import '../widgets/goal/saving_goal_card.dart';
import '../widgets/goal/goal_dialogs.dart';

class SavingGoalsScreen extends StatefulWidget {
  final int month;
  final int year;

  const SavingGoalsScreen({
    super.key,
    required this.month,
    required this.year,
  });

  @override
  State<SavingGoalsScreen> createState() => _SavingGoalsScreenState();
}

class _SavingGoalsScreenState extends State<SavingGoalsScreen> {
  void _showAddOrEditGoalDialog({SavingGoal? existingGoal}) async {
    final result = await showDialog<SavingGoal>(
      context: context,
      builder: (_) => AddOrEditGoalDialog(
        existingGoal: existingGoal,
        month: widget.month,
        year: widget.year,
      ),
    );

    if (result != null) {
      await DatabaseService.addOrUpdateSavingGoal(result);
    }
  }

  void _showTransactionDialog(SavingGoal goal, bool isDeposit) async {
    final result = await showDialog<SavingGoal>(
      context: context,
      builder: (_) => GoalTransactionDialog(
        goal: goal,
        isDeposit: isDeposit,
      ),
    );

    if (result != null) {
      await DatabaseService.addOrUpdateSavingGoal(result);
    }
  }

  void _showDeleteConfirmDialog(SavingGoal goal) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          title: const Text(
            'Xóa mục tiêu',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('Bạn có chắc chắn muốn xóa mục tiêu "${goal.name}" không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await DatabaseService.deleteSavingGoal(goal.id);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1015) : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('Mục tiêu tiết kiệm (${widget.month.toString().padLeft(2, '0')}/${widget.year})'),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: DatabaseService.getSavingGoalsBoxListenable(),
        builder: (context, Box box, _) {
          final allGoals = DatabaseService.getSavingGoals();
          final goals = allGoals.where((g) => g.isActiveIn(widget.month, widget.year)).toList();

          if (goals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.track_changes,
                    size: 80,
                    color: Colors.grey.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Không có mục tiêu nào trong tháng này',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _showAddOrEditGoalDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Tạo mục tiêu ngay'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return SavingGoalCard(
                goal: goal,
                onDeposit: () => _showTransactionDialog(goal, true),
                onWithdraw: () => _showTransactionDialog(goal, false),
                onEdit: () => _showAddOrEditGoalDialog(existingGoal: goal),
                onDelete: () => _showDeleteConfirmDialog(goal),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: () => _showAddOrEditGoalDialog(),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
