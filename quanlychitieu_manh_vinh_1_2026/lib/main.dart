import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {

  double balance = 5000000;
  double income = 3000000;
  double expense = 2000000;

  List<Map<String, dynamic>> transactions = [
    {"title": "Ăn uống", "amount": -50000},
    {"title": "Mua sắm", "amount": -200000},
    {"title": "Lương", "amount": 3000000},
    {"title": "Di chuyển", "amount": -30000},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý chi tiêu"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Số dư: $balance đ", style: TextStyle(fontSize: 20)),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Thu: +$income đ", style: TextStyle(color: Colors.green)),
                Text("Chi: -$expense đ", style: TextStyle(color: Colors.red)),
              ],
            ),

            SizedBox(height: 20),

            Text("Danh sách giao dịch:", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Column(
              children: transactions.map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item["title"]),
                      Text(
                        "${item["amount"]} đ",
                        style: TextStyle(
                          color: item["amount"] > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )

          ],
        ),
      ),
    );
  }
}