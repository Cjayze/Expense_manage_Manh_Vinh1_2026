import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/categories.dart';
import '../models/transaction.dart' hide DatabaseService;
import '../services/database_service.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  String selectedType = "Chi tiêu";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Biểu đồ"),
      ),
      body: ValueListenableBuilder(
        valueListenable: DatabaseService.getBox().listenable(),
        builder: (context, Box<TransactionModel> box, _) {
          print("Tong giao dich: ${box.values.length}");

          final transactions = box.values
              .where((tx) => tx.type == selectedType)
              .toList();

          final Map<String, double> categoryTotals = {};

          for (final tx in transactions) {
            categoryTotals[tx.categoryName] =
                (categoryTotals[tx.categoryName] ?? 0) +
                    tx.amount;
          }

          if (transactions.isEmpty) {
            return Center(
              child: Text(
                "Không có giao dịch $selectedType",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          final total =
              categoryTotals.values.fold(0.0, (a, b) => a + b);

          return Column(
            children: [
              const SizedBox(height: 20),

              DropdownButton<String>(
                value: selectedType,
                dropdownColor: Colors.black,
                items: const [
                  DropdownMenuItem(
                    value: "Chi tiêu",
                    child: Text("Chi tiêu"),
                  ),
                  DropdownMenuItem(
                    value: "Thu nhập",
                    child: Text("Thu nhập"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),

              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: categoryTotals.entries.map((e) {
                      return PieChartSectionData(
                        value: e.value,
                        title:
                            "${(e.value / total * 100).toStringAsFixed(1)}%",
                        color: _getCategoryColor(e.key),
                        radius: 100,
                      );
                    }).toList(),
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  children: categoryTotals.entries.map((e) {
                    return ListTile(
                      leading: Icon(
                        _getCategoryIcon(e.key),
                        color: _getCategoryColor(e.key),
                      ),
                      title: Text(
                        e.key,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        e.value.toStringAsFixed(0),
                        style: const TextStyle(color: Colors.amber),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getCategoryColor(String categoryName) {
    final all = [
      ...expenseCategories,
      ...incomeCategories,
    ];

    try {
      return all.firstWhere((e) => e.name == categoryName).color;
    } catch (_) {
      return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    final all = [
      ...expenseCategories,
      ...incomeCategories,
    ];

    try {
      return all.firstWhere((e) => e.name == categoryName).icon;
    } catch (_) {
      return Icons.category;
    }
  }
}