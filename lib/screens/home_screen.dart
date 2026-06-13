import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart' hide DatabaseService;
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../widgets/month_year_picker.dart';
import 'login_screen.dart';
import 'edit_transaction_screen.dart';
import 'profile_screen.dart';
import '../widgets/user_avatar.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {
  late int currentMonth;
  late int currentYear;

  @override
  void initState() {
    super.initState();

    currentMonth = DateTime.now().month;
    currentYear = DateTime.now().year;
  }

  Future<void> _editTransaction(
    TransactionModel tx,
  ) async {
    final amountController =
        TextEditingController(
      text: tx.amount.toString(),
    );

    final noteController =
        TextEditingController(
      text: tx.note,
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Sửa giao dịch",
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: "Số tiền",
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                decoration:
                    const InputDecoration(
                  labelText: "Ghi chú",
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text(
                "Hủy",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedTx =
                    TransactionModel(
                  id: tx.id,
                  type: tx.type,
                  categoryName:
                      tx.categoryName,
                  categoryIconCode:
                      tx.categoryIconCode,
                  categoryColorValue:
                      tx.categoryColorValue,
                  amount: double.tryParse(
                        amountController.text,
                      ) ??
                      tx.amount,
                  note:
                      noteController.text,
                  dateTime: tx.dateTime,
                );

                await DatabaseService
                    .updateTransaction(
                  updatedTx,
                );

                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Lưu",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat =
        NumberFormat("#,###", "vi_VN");

    return Scaffold(
      appBar: AppBar(
          title: const Text("Trang chủ"),
          actions: const [
            UserAvatar(),
          ],
        ),
      body: ValueListenableBuilder(
        valueListenable:
            DatabaseService.getBox()
                .listenable(),
        builder: (
          context,
          Box<TransactionModel> box,
          _,
        ) {
          final transactions =
              box.values.toList();

          final filteredTransactions =
              transactions
                  .where(
                    (tx) =>
                        tx.dateTime.month ==
                            currentMonth &&
                        tx.dateTime.year ==
                            currentYear,
                  )
                  .toList()
                ..sort(
                  (a, b) => b.dateTime
                      .compareTo(
                    a.dateTime,
                  ),
                );

          double totalExpense = 0;
          double totalIncome = 0;

          for (var tx
              in filteredTransactions) {
            if (tx.type ==
                "Chi tiêu") {
              totalExpense += tx.amount;
            } else {
              totalIncome += tx.amount;
            }
          }

          final balance =
              totalIncome - totalExpense;

          return ListView(
            children: [
              Container(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                color: theme.cardColor,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      '$currentYear',
                      style:
                          const TextStyle(
                        color:
                            Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        InkWell(
                          onTap:
                              () async {
                            final result =
                                await showDialog<
                                    Map<
                                        String,
                                        int>>(
                              context:
                                  context,
                              builder:
                                  (
                                    context,
                                  ) =>
                                      MonthYearPicker(
                                initialMonth:
                                    currentMonth,
                                initialYear:
                                    currentYear,
                              ),
                            );

                            if (result !=
                                null) {
                              setState(
                                () {
                                  currentMonth =
                                      result[
                                          'month']!;
                                  currentYear =
                                      result[
                                          'year']!;
                                },
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                'Thg $currentMonth',
                                style:
                                    TextStyle(
                                  color: theme
                                      .colorScheme
                                      .onSurface,
                                  fontSize:
                                      22,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons
                                    .keyboard_arrow_down,
                                color: theme
                                    .colorScheme
                                    .onSurface,
                              ),
                            ],
                          ),
                        ),
                        _buildHeaderStat(
                          'Chi tiêu',
                          currencyFormat
                              .format(
                            totalExpense,
                          ),
                        ),
                        _buildHeaderStat(
                          'Thu nhập',
                          currencyFormat
                              .format(
                            totalIncome,
                          ),
                        ),
                        _buildHeaderStat(
                          'Số dư',
                          currencyFormat
                              .format(
                            balance,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              ValueListenableBuilder<
                  bool>(
                valueListenable:
                    AuthService
                        .isLoggedIn,
                builder: (
                  context,
                  loggedIn,
                  _,
                ) {
                  if (loggedIn) {
                    return const SizedBox
                        .shrink();
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  LoginScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin:
                          const EdgeInsets
                              .all(16),
                      padding:
                          const EdgeInsets
                              .all(12),
                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFF2C1614,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          8,
                        ),
                      ),
                      child: const Text(
                        "Sau khi đăng nhập, bạn có thể sao lưu dữ liệu của mình trong thời gian thực!",
                        style: TextStyle(
                          color: Colors
                              .orange,
                        ),
                      ),
                    ),
                  );
                },
              ),

              if (filteredTransactions
                  .isEmpty)
                const Padding(
                  padding:
                      EdgeInsets.all(
                    40,
                  ),
                  child: Center(
                    child: Text(
                      "Không có giao dịch nào trong tháng này",
                      style: TextStyle(
                        color:
                            Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount:
                      filteredTransactions
                          .length,
                  itemBuilder:
                      (context, index) {
                    final tx =
                        filteredTransactions[
                            index];

                    return Dismissible(
                      key: Key(tx.id),
                      background:
                          Container(
                        color: Colors.red,
                        alignment:
                            Alignment
                                .centerRight,
                        padding:
                            const EdgeInsets
                                .only(
                          right: 20,
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors
                              .white,
                        ),
                      ),
                      onDismissed:
                          (_) async {
                        await DatabaseService
                            .deleteTransaction(
                          tx.id,
                        );
                      },
                      child: ListTile(
                        onTap: () =>
                            _editTransaction(
                          tx,
                        ),
                        leading:
                            CircleAvatar(
                          backgroundColor:
                              Color(
                            tx.categoryColorValue,
                          ),
                          child: Icon(
                            IconData(
                              tx.categoryIconCode,
                              fontFamily:
                                  'MaterialIcons',
                            ),
                            color: Colors
                                .black,
                          ),
                        ),
                        title: Text(
                          tx.categoryName,
                          style:
                              const TextStyle(
                            color: Colors
                                .white,
                          ),
                        ),
                        subtitle: Text(
                          tx.note.isEmpty
                              ? DateFormat(
                                  'dd/MM/yyyy',
                                ).format(
                                  tx.dateTime,
                                )
                              : tx.note,
                          style:
                              const TextStyle(
                            color: Colors
                                .grey,
                          ),
                        ),
                        trailing: Text(
                          "${tx.type == "Chi tiêu" ? "-" : "+"}${currencyFormat.format(tx.amount)} đ",
                          style:
                              TextStyle(
                            color: tx.type ==
                                    "Chi tiêu"
                                ? Colors
                                    .redAccent
                                : Colors
                                    .green,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderStat(
    String title,
    String value,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
