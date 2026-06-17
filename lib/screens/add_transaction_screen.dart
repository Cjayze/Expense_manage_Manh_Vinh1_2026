import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../models/categories.dart';
import '../models/transaction.dart';
import '../services/database_service.dart' as db;
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _amountStr = "0";
  CategoryItem? _selectedCategory;
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedCategory = expenseCategories.first;
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedCategory = _tabController.index == 0 ? expenseCategories.first : incomeCategories.first;
        });
      }
    });
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

    setState(() {
      _isSaving = true;
    });

    try {
      final String currentType = _tabController.index == 0 ? "Chi tiêu" : "Thu nhập";

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
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(fontSize: 16)),
        ),
        title: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: theme.colorScheme.onSurface,
          unselectedLabelColor: Colors.grey,
          tabs: const [Tab(text: "Chi tiêu"), Tab(text: "Thu nhập")],
        ),
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryGrid(expenseCategories),
                _buildCategoryGrid(incomeCategories),
              ],
            ),
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 16, crossAxisSpacing: 16),
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
                decoration: BoxDecoration(color: isSelected ? cat.color : theme.cardColor, shape: BoxShape.circle),
                child: Icon(cat.icon, color: isSelected ? Colors.black : theme.colorScheme.onSurface, size: 24),
              ),
              const SizedBox(height: 6),
              Text(cat.name, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface), overflow: TextOverflow.ellipsis),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomKeyboard() {
    final theme = Theme.of(context);
    final List<String> keys = ["7", "8", "9", "⌫", "4", "5", "6", "+", "1", "2", "3", "-", "C", "0", ".", "✓"];
    return Container(
      color: theme.cardColor,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 2.2),
        itemBuilder: (context, index) {
          final text = keys[index];
          return InkWell(
            onTap: () => text == "✓" ? _saveTransaction() : _onKeyPress(text),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: theme.dividerColor, width: 0.5)),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: text == "✓" ? Colors.amber : theme.colorScheme.onSurface),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
