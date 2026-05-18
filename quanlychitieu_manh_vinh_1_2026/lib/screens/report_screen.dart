import 'package:flutter/material.dart';
import '../components/nav_button.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Báo cáo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: const Color(0xFF1E1E1E),
              child: const Row(
                children: [
                  Expanded(child: NavButton(text: 'Phân tích', isSelected: true)),
                  SizedBox(width: 8),
                  Expanded(child: NavButton(text: 'Tài khoản', isSelected: false)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Thống kê hàng tháng', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Text('Thg 5', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Chi tiêu', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          SizedBox(height: 4),
                          Text('1.180.000', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Thu nhập', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          SizedBox(height: 4),
                          Text('0', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ngân sách hàng tháng', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey[800]!, width: 10),
                              ),
                              child: const Center(child: Text('--', style: TextStyle(color: Colors.grey, fontSize: 24))),
                            ),
                            const SizedBox(width: 20),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Text('Còn lại : ', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                  Text('-1.180.000', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                ]),
                                SizedBox(height: 12),
                                Row(children: [
                                  Text('Ngân sách : ', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                  Text('0', style: TextStyle(color: Colors.white, fontSize: 14)),
                                ]),
                                SizedBox(height: 8),
                                Row(children: [
                                  Text('Chi tiêu : ', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                  Text('1.180.000', style: TextStyle(color: Colors.white, fontSize: 14)),
                                ]),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green[800],
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: const Center(
                child: Text(
                  'Quảng cáo Grab',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}