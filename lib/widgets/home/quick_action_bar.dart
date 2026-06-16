import 'package:flutter/material.dart';

class QuickActionBar extends StatelessWidget {
  final VoidCallback onAddIncome;
  final VoidCallback onAddExpense;
  final VoidCallback onSettings;

  const QuickActionBar({
    super.key,
    required this.onAddIncome,
    required this.onAddExpense,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF181208),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          _item(Icons.post_add, 'Thêm\nthu', onAddIncome),
          _item(Icons.remove_circle_outline, 'Thêm\nchi', onAddExpense),
          _item(Icons.settings_outlined, 'Cài\nđặt', onSettings),
        ],
      ),
    );
  }

  Widget _item(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Color(0xFF2878FF),
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFEDE6DA),
                fontSize: 12,
                height: 1.1,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}