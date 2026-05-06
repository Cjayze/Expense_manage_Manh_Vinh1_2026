import 'package:flutter/material.dart';

import '../models/expense_item.dart';
import 'expense_item_card.dart';

class ExpenseMain extends StatelessWidget {
  final List<ExpenseItem> items;
  const ExpenseMain({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ExpenseItemCard(item: item),
          ),
        ),
      ],
    );
  }
}
