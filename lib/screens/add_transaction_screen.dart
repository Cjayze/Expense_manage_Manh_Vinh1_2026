import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../models/categories.dart';
import '../models/transaction.dart';
import '../services/database_service.dart' as db;

class AddTransactionScreen extends StatefulWidget {
  final int initialTabIndex;
  final DateTime? initialDate;
  const AddTransactionScreen({super.key, this.initialTabIndex = 0, this.initialDate});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String _amountStr = "0";
  CategoryItem? _selectedCategory;
  final TextEditingController _noteController = TextEditingController();
  late DateTime _selectedDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialTabIndex == 0
        ? expenseCategories.first
        : incomeCategories.first;
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  void _onKeyPress(String value) {
    setState(() {
      if (value == "C") {
        _amountStr = "0";
      } else if (value == "⌫") {
        if (_amountStr.length > 1) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
        } else {
          _amountStr = "0";
        }
      } else {
        if (_amountStr == "0") {
          _amountStr = value;
        } else {
          _amountStr += value;
        }
      }
    });
  }

  Future<void> _saveTransaction() async {
    if (_isSaving) return;

    final double parsedAmount = double.tryParse(_amountStr) ?? 0;
    if (parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập số tiền hợp lệ!")),
      );
      return;
    }

    final String currentType = widget.initialTabIndex == 0 ? "Chi tiêu" : "Thu nhập";

    if (currentType == "Chi tiêu") {
      final transactions = db.DatabaseService.getFilteredTransactions(
        month: _selectedDate.month,
        year: _selectedDate.year,
      );
      final summary = db.DatabaseService.getMonthSummary(
        transactions: transactions,
        month: _selectedDate.month,
        year: _selectedDate.year,
      );
      final double balance = summary['balance'] as double;

      final goals = db.DatabaseService.getSavingGoals();
      final activeGoals = goals.where((g) => g.isActiveIn(_selectedDate.month, _selectedDate.year)).toList();
      double goalsAccumulated = 0.0;
      for (var g in activeGoals) {
        goalsAccumulated += g.currentAmount;
      }

      final double availableBalance = balance - goalsAccumulated;

      if (parsedAmount > availableBalance) {
        final result = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Vượt quá số dư khả dụng'),
              content: const Text(
                'Khoản chi vượt quá số dư khả dụng. Bạn có muốn rút từ mục tiêu tiết kiệm không?'
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'cancel'),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'withdraw'),
                  child: const Text('Rút từ mục tiêu'),
                ),
              ],
            );
          },
        );

        if (result == 'withdraw') {
          double neededAmount = parsedAmount - availableBalance;
          for (var goal in activeGoals) {
            if (neededAmount <= 0) break;
            if (goal.currentAmount > 0) {
              final deduct = goal.currentAmount >= neededAmount ? neededAmount : goal.currentAmount;
              final updatedGoal = goal.copyWith(
                currentAmount: goal.currentAmount - deduct,
                updatedAt: DateTime.now(),
              );
              await db.DatabaseService.addOrUpdateSavingGoal(updatedGoal);
              neededAmount -= deduct;
            }
          }
        } else {
          return;
        }
      }
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final newTx = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: currentType,
        categoryName: _selectedCategory!.name,
        categoryIconCode: _selectedCategory!.icon.codePoint,
        categoryColorValue: _selectedCategory!.color.value,
        amount: parsedAmount,
        note: _noteController.text,
        dateTime: _selectedDate,
      );

      await db.DatabaseService.addTransaction(newTx);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = intl.NumberFormat("#,###", "vi_VN");

    final isIncome = widget.initialTabIndex == 1;
    final title = isIncome ? "Thêm thu nhập" : "Thêm chi tiêu";
    final categories = isIncome ? incomeCategories : expenseCategories;

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(fontSize: 16)),
        ),
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildCategoryGrid(categories),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.cardColor,
            child: Row(
              children: [
                const Icon(Icons.assignment_outlined, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(hintText: "Nhập ghi chú...", border: InputBorder.none),
                  ),
                ),
                Text(
                  currencyFormat.format(double.tryParse(_amountStr) ?? 0),
                  style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _buildCustomKeyboard(),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(List<CategoryItem> categories) {
    final theme = Theme.of(context);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = _selectedCategory?.name == cat.name;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? cat.color : theme.cardColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  cat.icon,
                  color: isSelected ? Colors.black : theme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                cat.name,
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomKeyboard() {
    final theme = Theme.of(context);
    final List<String> keys = [
      "7", "8", "9", "⌫",
      "4", "5", "6", "+",
      "1", "2", "3", "-",
      "C", "0", ".", "✓"
    ];
    return Container(
      color: theme.cardColor,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          final text = keys[index];
          return InkWell(
            onTap: () => text == "✓" ? _saveTransaction() : _onKeyPress(text),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor, width: 0.5),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: text == "✓" ? Colors.amber : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
