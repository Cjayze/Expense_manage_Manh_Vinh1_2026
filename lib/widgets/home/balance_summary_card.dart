import 'package:flutter/material.dart';

class BalanceSummaryCard extends StatelessWidget {
  final String monthText;
  final String balanceText;
  final double savingRate;
  final VoidCallback onTapMonth;

  const BalanceSummaryCard({
    super.key,
    required this.monthText,
    required this.balanceText,
    required this.savingRate,
    required this.onTapMonth,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (savingRate * 100).toStringAsFixed(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFDFF5FF),
            Color(0xFFE9FFD9),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTapMonth,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  monthText,
                  style: const TextStyle(
                    color: Color(0xFF172033),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF172033),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Số dư hiện tại',
            style: TextStyle(
              color: Color(0xFF6C7890),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            balanceText,
            style: const TextStyle(
              color: Color(0xFF172033),
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: savingRate,
              minHeight: 10,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFF2FC866),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tỷ lệ giữ lại: $percent%',
            style: const TextStyle(
              color: Color(0xFF6C7890),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}