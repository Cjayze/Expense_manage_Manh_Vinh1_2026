import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/categories.dart';
import '../../services/database_service.dart';

class BudgetManagementSheet extends StatefulWidget {
  final Map<String, double> categoryExpenses;
  final int month;
  final int year;
  final VoidCallback onBudgetChanged;

  const BudgetManagementSheet({
    super.key,
    required this.categoryExpenses,
    required this.month,
    required this.year,
    required this.onBudgetChanged,
  });

  @override
  State<BudgetManagementSheet> createState() => _BudgetManagementSheetState();
}

class _BudgetManagementSheetState extends State<BudgetManagementSheet> {
  final _formatter = NumberFormat('#,###', 'vi_VN');

  Future<double?> _showSingleCategoryBudgetDialog(
    BuildContext context,
    String categoryName,
    double currentLimit,
  ) async {
    final controller = TextEditingController(
      text: currentLimit > 0 ? currentLimit.toInt().toString() : '',
    );
    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ngân sách: $categoryName'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Hạn mức chi tiêu (đ)',
              helperText: 'Nhập 0 để xóa ngân sách',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final cleanStr = controller.text.replaceAll(RegExp(r'[^0-9]'), '');
                final val = double.tryParse(cleanStr) ?? 0.0;
                Navigator.pop(context, val);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgets = DatabaseService.getCategoryBudgets(
      month: widget.month,
      year: widget.year,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Tính toán thông tin tháng trước để hỗ trợ sao chép
    int prevMonth = widget.month - 1;
    int prevYear = widget.year;
    if (prevMonth == 0) {
      prevMonth = 12;
      prevYear = widget.year - 1;
    }
    final prevMonthStr = prevMonth.toString().padLeft(2, '0');
    final prevBudgets = DatabaseService.getCategoryBudgets(
      month: prevMonth,
      year: prevYear,
    );
    final bool canInherit = budgets.isEmpty && prevBudgets.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Quản lý ngân sách',
              style: TextStyle(
                color: isDark ? const Color(0xFFEDE6DA) : const Color(0xFF172033),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (canInherit) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () async {
                  for (final entry in prevBudgets.entries) {
                    await DatabaseService.setCategoryBudget(
                      categoryName: entry.key,
                      limit: entry.value,
                      month: widget.month,
                      year: widget.year,
                    );
                  }
                  setState(() {});
                  widget.onBudgetChanged();
                },
                icon: const Icon(Icons.copy, size: 16, color: Colors.amber),
                label: Text(
                  'Sao chép ngân sách từ tháng $prevMonthStr/$prevYear',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: expenseCategories.length,
                itemBuilder: (context, index) {
                  final category = expenseCategories[index];
                  final spent = widget.categoryExpenses[category.name] ?? 0.0;
                  final limit = budgets[category.name] ?? 0.0;
                  final hasLimit = limit > 0;
                  final progress = hasLimit ? (spent / limit).clamp(0.0, 1.0) : 0.0;
                  final isExceeded = hasLimit && spent > limit;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0D1015) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                    ),
                    child: InkWell(
                      onTap: () async {
                        final newLimit = await _showSingleCategoryBudgetDialog(
                          context,
                          category.name,
                          limit,
                        );
                        if (newLimit != null) {
                          await DatabaseService.setCategoryBudget(
                            categoryName: category.name,
                            limit: newLimit,
                            month: widget.month,
                            year: widget.year,
                          );
                          setState(() {});
                          widget.onBudgetChanged();
                        }
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: category.color.withValues(alpha: 0.2),
                            child: Icon(category.icon, color: category.color),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.name,
                                  style: TextStyle(
                                    color: isDark ? Colors.white : const Color(0xFF172033),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  hasLimit
                                      ? 'Ngân sách: ${_formatter.format(limit)} đ | Đã chi: ${_formatter.format(spent)} đ'
                                      : 'Đã chi: ${_formatter.format(spent)} đ (Chưa đặt ngân sách)',
                                  style: TextStyle(
                                    color: isExceeded
                                        ? Colors.redAccent
                                        : (isDark ? Colors.grey : const Color(0xFF6C7890)),
                                    fontSize: 12,
                                  ),
                                ),
                                if (hasLimit) ...[
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(99),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 6,
                                      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                                      valueColor: AlwaysStoppedAnimation(
                                        isExceeded ? Colors.redAccent : Colors.greenAccent,
                                      ),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                          const Icon(Icons.edit, color: Colors.grey, size: 18),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
