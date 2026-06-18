import 'package:flutter/material.dart';

class QuickActionBar extends StatelessWidget {
  final VoidCallback onAddIncome;
  final VoidCallback onAddExpense;

  const QuickActionBar({
    super.key,
    required this.onAddIncome,
    required this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF181B22) : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildQuickActionButton(
            context: context,
            icon: Icons.add,
            label: 'Thêm thu nhập',
            iconColor: const Color(0xFF16A34A),
            circleBgColor: const Color(0xFFDCFCE7),
            onTap: onAddIncome,
          ),
          const SizedBox(width: 24),
          Container(
            height: 24,
            width: 1,
            color: isDark ? const Color(0xFF2C313C) : const Color(0xFFF3F4F6),
          ),
          const SizedBox(width: 24),
          _buildQuickActionButton(
            context: context,
            icon: Icons.remove,
            label: 'Thêm chi tiêu',
            iconColor: const Color(0xFFEF4444),
            circleBgColor: const Color(0xFFFEE2E2),
            onTap: onAddExpense,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color circleBgColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFEDE6DA) : const Color(0xFF172033);

    return SizedBox(
      width: 95,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: circleBgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}