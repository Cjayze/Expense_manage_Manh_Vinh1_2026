import 'package:flutter/material.dart';

class ExpenseHomePage extends StatelessWidget {
  const ExpenseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2D5A27);
    const Color accentOrange = Color(0xFFD35400);
    const Color backgroundCream = Color(0xFFFAF9F6);

    return Scaffold(
      backgroundColor: backgroundCream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- TỔNG QUAN CHI TIÊU ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              child: Column(
                children: [
                  const Text('Tổng chi tiêu tháng này', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 10),
                  const Text('2.450.000đ', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'serif')),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMiniStat('Thu nhập', '10M', primaryGreen),
                      const SizedBox(width: 40),
                      _buildMiniStat('Đã chi', '2.4M', accentOrange),
                    ],
                  ),
                ],
              ),
            ),

            // --- HÌNH ẢNH NGHỆ THUẬT ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: _buildArtImage('https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=500', 300)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('"Quản lý chi tiêu là cách tận hưởng cuộc sống bền vững."', 
                          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12), textAlign: TextAlign.center),
                        const SizedBox(height: 15),
                        _buildArtImage('https://images.unsplash.com/photo-1544145945-f904253d0c7b?w=500', 180),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- DANH SÁCH CHI TIÊU ---
            Container(
              margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CHI TIÊU HÔM NAY', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildCategory('Đồ ăn', ['Bún chả: 50k', 'Bánh mì: 20k'], primaryGreen),
                  const SizedBox(height: 20),
                  _buildCategory('Đồ uống', ['Cà phê: 35k', 'Trà đào: 45k'], accentOrange),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
    ]);
  }

  Widget _buildArtImage(String url, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildCategory(String title, List<String> items, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ...items.map((i) => Text('• $i', style: const TextStyle(fontSize: 16))).toList(),
    ]);
  }
}