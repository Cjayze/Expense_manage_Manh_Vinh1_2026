import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/transaction.dart';

class RecentTransactionTile extends StatelessWidget {
  static final _formatter = NumberFormat('#,###', 'vi_VN');

  final TransactionModel transaction;
  final VoidCallback onTap;
  final DismissDirectionCallback onDismissed;

  const RecentTransactionTile({
    super.key,
    required this.transaction,
    required this.onTap,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == 'Chi tiêu';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: onDismissed,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF181B22) : Colors.white,
            borderRadius: BorderRadius.circular(18),
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
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Color(transaction.categoryColorValue),
                child: Icon(
                  IconData(
                    transaction.categoryIconCode,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.categoryName,
                      style: TextStyle(
                        color: isDark ? const Color(0xFFF3F4F6) : const Color(0xFF172033),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.note.isEmpty
                          ? DateFormat('dd/MM/yyyy').format(transaction.dateTime)
                          : transaction.note,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? const Color(0xFF8E99AA) : const Color(0xFF6C7890),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${isExpense ? '-' : '+'}${_formatter.format(transaction.amount)} đ',
                style: TextStyle(
                  color: isExpense ? Colors.redAccent : Colors.greenAccent,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}