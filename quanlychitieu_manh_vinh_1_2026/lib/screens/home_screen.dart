import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Số Thu Chi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          pinned: true,
          actions: [
            IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
            IconButton(icon: const Icon(Icons.calendar_today_outlined, color: Colors.white), onPressed: () {}),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFF1E1E1E),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('2026', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('Thg 5', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      ],
                    ),
                    const Row(
                      children: [
                        Text('Chi tiêu', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        SizedBox(width: 8),
                        Text('Thu nhập', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        SizedBox(width: 8),
                        Text('Số dư', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('1.180.000', style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(width: 16),
                    const Text('0', style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(width: 16),
                    const Text('-1.180.000', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.redAccent),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sau khi đăng nhập, bạn có thể sao lưu dữ liệu của mình trong thời gian thực!',
                    style: TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.redAccent),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => TransactionItem(index: index),
            childCount: 4,
          ),
        ),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final int index;
  const TransactionItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<String> titles = ["Đi lại", "Giáo dục", "Đồ ăn", "Mua sắm"];
    List<IconData> icons = [Icons.directions_bus_outlined, Icons.school_outlined, Icons.restaurant_outlined, Icons.shopping_cart_outlined];
    List<Color> colors = [Colors.redAccent, Colors.orangeAccent, Colors.tealAccent, Colors.amber];
    List<String> amounts = ["-30.000", "-1.000.000", "-50.000", "-100.000"];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: colors[index], shape: BoxShape.circle),
            child: Icon(icons[index], color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(titles[index], style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          Text(amounts[index], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}