import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../components/nav_button.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          title: DropdownButton<String>(
            value: 'Chi tiêu',
            dropdownColor: const Color(0xFF1E1E1E),
            items: <String>['Chi tiêu', 'Thu nhập'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              );
            }).toList(),
            onChanged: (_) {},
            underline: Container(),
          ),
          pinned: true,
          actions: [
            IconButton(icon: const Icon(Icons.calendar_today_outlined, color: Colors.white), onPressed: () {}),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFF1E1E1E),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      NavButton(text: 'Tuần', isSelected: false),
                      NavButton(text: 'Tháng', isSelected: true),
                      NavButton(text: 'Năm', isSelected: false),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CircularPercentIndicator(
                      radius: 50.0,
                      lineWidth: 12.0,
                      percent: 0.84,
                      center: const Text(
                        "+1,18 tr",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.white),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.grey[800]!,
                      progressColor: Colors.amber,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      ChartLegendItem(color: Colors.orangeAccent, title: 'Giáo dục', percentage: '84,74%'),
                      ChartLegendItem(color: Colors.amber, title: 'Mua sắm', percentage: '8,47%'),
                      ChartLegendItem(color: Colors.tealAccent, title: 'Đồ ăn', percentage: '4,23%'),
                      ChartLegendItem(color: Colors.redAccent, title: 'Đi lại', percentage: '2,54%'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ChartCategoryItem(index: index),
            childCount: 4,
          ),
        ),
      ],
    );
  }
}

class ChartLegendItem extends StatelessWidget {
  final Color color;
  final String title;
  final String percentage;
  const ChartLegendItem({super.key, required this.color, required this.title, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          Text(percentage, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}

class ChartCategoryItem extends StatelessWidget {
  final int index;
  const ChartCategoryItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<String> titles = ["Giáo dục", "Mua sắm", "Đồ ăn", "Đi lại"];
    List<IconData> icons = [Icons.school_outlined, Icons.shopping_cart_outlined, Icons.restaurant_outlined, Icons.directions_bus_outlined];
    List<Color> colors = [Colors.orangeAccent, Colors.amber, Colors.tealAccent, Colors.redAccent];
    List<String> percentages = ["84,74%", "8,47%", "4,23%", "2,54%"];
    List<String> amounts = ["1.000.000", "100.000", "50.000", "30.000"];
    List<double> progressFactors = [0.84, 0.3, 0.15, 0.1];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: colors[index], shape: BoxShape.circle),
            child: Icon(icons[index], color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${titles[index]} ${percentages[index]}", style: const TextStyle(color: Colors.white, fontSize: 16)),
                    Text(amounts[index], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progressFactors[index],
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEB3B),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}