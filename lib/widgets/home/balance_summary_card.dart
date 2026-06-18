import 'package:flutter/material.dart';

class BalanceSummaryCard extends StatelessWidget {
  final String monthText;
  final String availableText;
  final String goalsAccumulatedText;
  final String totalAssetsText;
  final double savingRate;
  final VoidCallback onTapMonth;

  const BalanceSummaryCard({
    super.key,
    required this.monthText,
    required this.availableText,
    required this.goalsAccumulatedText,
    required this.totalAssetsText,
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
          const SizedBox(height: 20),
          const Text(
            'Số dư khả dụng',
            style: TextStyle(
              color: Color(0xFF6C7890),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            availableText,
            style: const TextStyle(
              color: Color(0xFF172033),
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tích lũy mục tiêu',
                      style: TextStyle(color: Color(0xFF6C7890), fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      goalsAccumulatedText,
                      style: const TextStyle(
                        color: Color(0xFF172033),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tổng tài sản',
                      style: TextStyle(color: Color(0xFF6C7890), fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      totalAssetsText,
                      style: const TextStyle(
                        color: Color(0xFF172033),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: savingRate,
              minHeight: 8,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation(
                Color(0xFF2FC866),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tỷ lệ giữ lại: $percent%',
            style: const TextStyle(
              color: Color(0xFF6C7890),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}