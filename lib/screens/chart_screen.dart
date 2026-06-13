import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart' hide DatabaseService;
import '../services/database_service.dart';
import '../widgets/user_avatar.dart';
class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  bool isMonthView = true;

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat("#,###", "vi_VN");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Biểu đồ"),
        actions: const [
          UserAvatar(),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: DatabaseService.getBox().listenable(),
        builder: (context, Box<TransactionModel> box, _) {
          final transactions = box.values.where((tx) {
            if (tx.type != "Chi tiêu") return false;

            if (isMonthView) {
              return tx.dateTime.month == selectedMonth &&
                  tx.dateTime.year == selectedYear;
            }

            return tx.dateTime.year == selectedYear;
          }).toList();

          Map<String, Map<String, dynamic>> categoryData = {};

          for (var tx in transactions) {
            if (categoryData.containsKey(tx.categoryName)) {
              categoryData[tx.categoryName]!['amount'] += tx.amount;
            } else {
              categoryData[tx.categoryName] = {
                'amount': tx.amount,
                'icon': tx.categoryIconCode,
                'color': tx.categoryColorValue,
              };
            }
          }

          double totalExpense = 0;

          for (var item in categoryData.values) {
            totalExpense += item['amount'];
          }

          final sortedCategories = categoryData.entries.toList()
            ..sort(
              (a, b) => (b.value['amount'] as double)
                  .compareTo(a.value['amount'] as double),
            );

          return Column(
            children: [
              const SizedBox(height: 16),

              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMonthView = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isMonthView
                                ? theme.colorScheme.primaryContainer
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Tháng",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isMonthView
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMonthView = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: !isMonthView
                                ? theme.colorScheme.primaryContainer
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Năm",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !isMonthView
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              if (isMonthView)
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedMonth--;

                          if (selectedMonth < 1) {
                            selectedMonth = 12;
                            selectedYear--;
                          }
                        });
                      },
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text(
                      "Tháng $selectedMonth/$selectedYear",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedMonth++;

                          if (selectedMonth > 12) {
                            selectedMonth = 1;
                            selectedYear++;
                          }
                        });
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedYear--;
                        });
                      },
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text(
                      "Năm $selectedYear",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedYear++;
                        });
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              if (totalExpense == 0)
                const Expanded(
                  child: Center(
                    child: Text(
                      "Không có dữ liệu",
                      style:
                          TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 280,
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: 70,
                            sectionsSpace: 2,
                            sections: List.generate(
                              sortedCategories.length,
                              (index) {
                                final item =
                                    sortedCategories[index];

                                return PieChartSectionData(
                                  value: item.value['amount'],
                                  color: Color(
                                    item.value['color'],
                                  ),
                                  radius: 55,
                                  showTitle: false,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      Center(
                        child: Text(
                          "${currencyFormat.format(totalExpense)} đ",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      ...List.generate(
                        sortedCategories.length,
                        (index) {
                          final item =
                              sortedCategories[index];

                          final amount =
                              item.value['amount']
                                  as double;

                          final iconCode =
                              item.value['icon']
                                  as int;

                          final colorValue =
                              item.value['color']
                                  as int;

                          final percent =
                              amount /
                                  totalExpense *
                                  100;

                          return Container(
                            margin:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            padding:
                                const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      Color(
                                    colorValue,
                                  ),
                                  child: Icon(
                                    IconData(
                                      iconCode,
                                      fontFamily:
                                          'MaterialIcons',
                                    ),
                                    color: Colors.black,
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.key,
                                              style:
                                                  TextStyle(
                                                color: theme
                                                    .colorScheme
                                                    .onSurface,
                                                fontSize:
                                                    17,
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${percent.toStringAsFixed(1)}%",
                                            style:
                                                TextStyle(
                                              color: theme
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 8,
                                      ),

                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          10,
                                        ),
                                        child:
                                            LinearProgressIndicator(
                                          value:
                                              percent /
                                                  100,
                                          minHeight:
                                              10,
                                          backgroundColor:
                                              theme.dividerColor,
                                          valueColor:
                                              const AlwaysStoppedAnimation(
                                            Colors
                                                .amber,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Text(
                                  currencyFormat
                                      .format(
                                    amount,
                                  ),
                                  style:
                                      TextStyle(
                                    color: theme
                                        .colorScheme
                                        .onSurface,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
