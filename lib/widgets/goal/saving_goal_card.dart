import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/financial_models.dart';

class SavingGoalCard extends StatelessWidget {
  final SavingGoal goal;
  final VoidCallback onDeposit;
  final VoidCallback onWithdraw;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SavingGoalCard({
    super.key,
    required this.goal,
    required this.onDeposit,
    required this.onWithdraw,
    required this.onEdit,
    required this.onDelete,
  });

  static final _formatter = NumberFormat('#,###', 'vi_VN');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = goal.calculateProgress();

    return Card(
      color: isDark ? const Color(0xFF181B22) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.name,
                    style: TextStyle(
                      color: isDark ? const Color(0xFFEDE6DA) : const Color(0xFF172033),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  goal.getGoalStatus(),
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Đã tích lũy: ${_formatter.format(goal.currentAmount)} / ${_formatter.format(goal.targetAmount)} đ',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                color: progress >= 1.0 ? Colors.green : Colors.teal,
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(progress * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  color: isDark ? const Color(0xFFEDE6DA) : const Color(0xFF172033),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 24, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Colors.green),
                      onPressed: onDeposit,
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      label: const Text('Gửi thêm', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                      onPressed: onWithdraw,
                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                      label: const Text('Rút ra', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 20),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      onPressed: onDelete,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
