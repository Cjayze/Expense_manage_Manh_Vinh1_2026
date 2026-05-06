import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../models/expense_item.dart';
import '../widgets/app_header.dart';
import '../widgets/expense_main.dart';
import '../widgets/expense_summary_card.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final List<ExpenseItem> items = const [
    ExpenseItem(name: 'Ăn uống', pricePerLb: 5.99, quantity: 1.0, emoji: '🍅'),
    ExpenseItem(name: 'Ăn uống', pricePerLb: 5.99, quantity: 1.0, emoji: '🍅'),
    ExpenseItem(name: 'Ăn uống', pricePerLb: 5.99, quantity: 1.0, emoji: '🍅'),

  ];

  double get subtotal => items.fold(0, (sum, i) => sum + i.total);
  double get shipping => 3.99;
  double get tax => 2.00;
  double get total => subtotal + shipping + tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;

                if (isWide) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ExpenseHeader(itemCount: items.length),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ExpenseMain(items: items),
                            ),
                            const SizedBox(width: 24),
                            SizedBox(
                              width: 300,
                              child: ExpenseSummaryCard(
                                subtotal: subtotal,
                                shipping: shipping,
                                tax: tax,
                                total: total,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _ExpenseHeader(itemCount: items.length),
                      const SizedBox(height: 16),
                      ExpenseMain(items: items),
                      const SizedBox(height: 24),
                      ExpenseSummaryCard(
                        subtotal: subtotal,
                        shipping: shipping,
                        tax: tax,
                        total: total,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseHeader extends StatelessWidget {
  final int itemCount;

  const _ExpenseHeader({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text(
              'Chi tiêu',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w400,
                fontFamily: 'Georgia',
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$itemCount khoản',
              style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(color: AppColors.divider),
      ],
    );
  }
}
