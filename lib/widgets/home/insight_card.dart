import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  final String message;

  const InsightCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171107),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF66532D),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0B8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFEDE6DA),
                fontSize: 15,
                height: 1.3,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}