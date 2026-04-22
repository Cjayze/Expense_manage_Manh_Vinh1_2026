import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'services/list_transaction.dart';
import 'services/generic_class.dart';

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

  final manager = ListTransaction();

  HomeScreen() {
    manager.create(Transaction(id: 1, title: "Ăn uống", amount: -50000));
    manager.create(Transaction(id: 2, title: "Mua sắm", amount: -200000));
    manager.create(Transaction(id: 3, title: "Lương", amount: 3000000));
  }

  @override
  Widget build(BuildContext context) {

    var data = manager.read();
    var generic = GenericClass<List<Transaction>>(data);

    return Scaffold(
      appBar: AppBar(title: Text("Quản lý chi tiêu")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            Text("Số dư: $balance đ"),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Thu: +$income đ", style: TextStyle(color: Colors.green)),
                Text("Chi: -$expense đ", style: TextStyle(color: Colors.red)),
              ],
            ),

            SizedBox(height: 20),

            Column(
              children: generic.obj.map((item) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ID: ${item.id}"),
                    Text(item.title),
                    Text(
                      "${item.amount} đ",
                      style: TextStyle(
                        color: item.amount > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                );
              }).toList(),
            )

          ],
        ),
      ),
    );
  }
}