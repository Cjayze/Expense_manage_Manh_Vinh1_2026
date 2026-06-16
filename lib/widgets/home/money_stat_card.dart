import 'package:flutter/material.dart';

class MoneyStatCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const MoneyStatCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 112,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.25,
                child: Icon(
                  icon,
                  size: 48,
                  color: iconColor,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF172033),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  amount,
                  style: const TextStyle(
                    color: Color(0xFF26324A),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}