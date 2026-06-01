import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../services/auth_service.dart';
import '../widgets/month_year_picker.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentMonth = 5;
  int currentYear = 2026;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat("#,###", "vi_VN");

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Sổ Thu Chi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ValueListenableBuilder(
        valueListenable: DatabaseService.getBox().listenable(),
        builder: (context, Box<TransactionModel> box, _) {
          // Lọc danh sách giao dịch theo tháng và năm được chọn
          final allTransactions = box.values.toList();
          final filteredTransactions = allTransactions.where((tx) {
            return tx.dateTime.month == currentMonth && tx.dateTime.year == currentYear;
          }).toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));

          double totalExpense = 0;
          double totalIncome = 0;
          for (var tx in filteredTransactions) {
            if (tx.type == "Chi tiêu") {
              totalExpense += tx.amount;
            } else {
              totalIncome += tx.amount;
            }
          }
          double balance = totalIncome - totalExpense;

          return ListView(
            children: [
              // Khối Tổng Quan Số Dư Đầu Trang có sự kiện đổi tháng
              Container(
                padding: const EdgeInsets.all(16),
                color: const Color(0xFF1E1E1E),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$currentYear', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            final result = await showDialog<Map<String, int>>(
                              context: context,
                              builder: (context) => MonthYearPicker(initialMonth: currentMonth, initialYear: currentYear),
                            );
                            if (result != null) {
                              setState(() {
                                currentMonth = result['month']!;
                                currentYear = result['year']!;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text('Thg $currentMonth', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                            ],
                          ),
                        ),
                        _buildHeaderStat('Chi tiêu', currencyFormat.format(totalExpense)),
                        _buildHeaderStat('Thu nhập', currencyFormat.format(totalIncome)),
                        _buildHeaderStat('Số dư', currencyFormat.format(balance)),
                      ],
                    ),
                  ],
                ),
              ),

              // Banner Đăng nhập ẩn/hiện động dựa trên Auth
              ValueListenableBuilder<bool>(
                valueListenable: AuthService.isLoggedIn,
                builder: (context, loggedIn, _) {
                  if (loggedIn) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFF2C1614), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Sau khi đăng nhập, bạn có thể sao lưu dữ liệu của mình trong thời gian thực!',
                              style: TextStyle(color: Colors.orange[800], fontSize: 13),
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),

              if (filteredTransactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Center(child: Text("Không có giao dịch nào trong tháng này", style: TextStyle(color: Colors.grey))),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Danh sách chi tiết (Thg $currentMonth)', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      Text('Tổng chi: ${currencyFormat.format(totalExpense)}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final tx = filteredTransactions[index];
                    return Dismissible(
                      key: Key(tx.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) => DatabaseService.deleteTransaction(tx.id),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(tx.categoryColorValue),
                          child: Icon(IconData(tx.categoryIconCode, fontFamily: 'MaterialIcons'), color: Colors.black),
                        ),
                        title: Text(tx.categoryName, style: const TextStyle(color: Colors.white, fontSize: 15)),
                        subtitle: Text(
                          tx.note.isEmpty ? DateFormat('dd/MM/yyyy').format(tx.dateTime) : tx.note,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Text(
                          "${tx.type == "Chi tiêu" ? "-" : "+"}${currencyFormat.format(tx.amount)} đ",
                          style: TextStyle(
                            color: tx.type == "Chi tiêu" ? Colors.redAccent : Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                )
              ]
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderStat(String title, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}