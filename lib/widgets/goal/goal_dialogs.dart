import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/financial_models.dart';

class AddOrEditGoalDialog extends StatefulWidget {
  final SavingGoal? existingGoal;
  final int month;
  final int year;

  const AddOrEditGoalDialog({
    super.key,
    this.existingGoal,
    required this.month,
    required this.year,
  });

  @override
  State<AddOrEditGoalDialog> createState() => _AddOrEditGoalDialogState();
}

class _AddOrEditGoalDialogState extends State<AddOrEditGoalDialog> {
  late final TextEditingController nameController;
  late final TextEditingController targetController;
  late final TextEditingController currentController;
  late DateTime selectedDeadline;
  late final bool isEdit;

  @override
  void initState() {
    super.initState();
    isEdit = widget.existingGoal != null;
    nameController = TextEditingController(text: widget.existingGoal?.name ?? '');
    targetController = TextEditingController(
        text: widget.existingGoal != null ? widget.existingGoal!.targetAmount.toStringAsFixed(0) : '');
    currentController = TextEditingController(
        text: widget.existingGoal != null ? widget.existingGoal!.currentAmount.toStringAsFixed(0) : '0');
    selectedDeadline = widget.existingGoal?.deadline ??
        DateTime(widget.year, widget.month, 1).add(const Duration(days: 30));
  }

  @override
  void dispose() {
    nameController.dispose();
    targetController.dispose();
    currentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      title: Text(
        isEdit ? 'Sửa mục tiêu' : 'Mục tiêu mới',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tên mục tiêu (VD: Mua Laptop)',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Số tiền mục tiêu (đ)',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!isEdit) ...[
              TextField(
                controller: currentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền đã có sẵn (đ)',
                  labelStyle: TextStyle(color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hạn chót:',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDeadline,
                      firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 20)),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDeadline = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(selectedDeadline),
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            final name = nameController.text.trim();
            final targetVal = double.tryParse(targetController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
            final currentVal = double.tryParse(currentController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vui lòng nhập tên mục tiêu')),
              );
              return;
            }
            if (targetVal <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Số tiền mục tiêu phải lớn hơn 0')),
              );
              return;
            }
            if (currentVal < 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Số tiền tích lũy hiện tại không được âm')),
              );
              return;
            }
            final selectedStart = DateTime(selectedDeadline.year, selectedDeadline.month, 1);
            final viewStart = DateTime(widget.year, widget.month, 1);
            if (selectedStart.isBefore(viewStart)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hạn chót không được trước tháng đang chọn')),
              );
              return;
            }

            final result = SavingGoal(
              id: widget.existingGoal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
              name: name,
              targetAmount: targetVal,
              currentAmount: isEdit ? widget.existingGoal!.currentAmount : currentVal,
              deadline: selectedDeadline,
              createdAt: widget.existingGoal?.createdAt ?? DateTime(widget.year, widget.month, 1),
              updatedAt: DateTime.now(),
            );

            Navigator.pop(context, result);
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}

class GoalTransactionDialog extends StatefulWidget {
  final SavingGoal goal;
  final bool isDeposit;

  const GoalTransactionDialog({
    super.key,
    required this.goal,
    required this.isDeposit,
  });

  @override
  State<GoalTransactionDialog> createState() => _GoalTransactionDialogState();
}

class _GoalTransactionDialogState extends State<GoalTransactionDialog> {
  final amountController = TextEditingController();
  static final _formatter = NumberFormat('#,###', 'vi_VN');

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      title: Text(
        widget.isDeposit ? 'Gửi thêm tiền' : 'Rút tiền',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Mục tiêu: ${widget.goal.name}',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Số tiền (${widget.isDeposit ? "gửi" : "rút"})',
              labelStyle: const TextStyle(color: Colors.grey),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.amber),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            final amount = double.tryParse(amountController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

            if (amount <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vui lòng nhập số tiền lớn hơn 0')),
              );
              return;
            }

            if (!widget.isDeposit && amount > widget.goal.currentAmount) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Số tiền rút không được vượt quá số dư hiện tại (${_formatter.format(widget.goal.currentAmount)} đ)',
                  ),
                ),
              );
              return;
            }

            final result = widget.goal.copyWith(
              currentAmount: widget.isDeposit
                  ? widget.goal.currentAmount + amount
                  : widget.goal.currentAmount - amount,
              updatedAt: DateTime.now(),
            );

            Navigator.pop(context, result);
          },
          child: const Text('Thực hiện'),
        ),
      ],
    );
  }
}
