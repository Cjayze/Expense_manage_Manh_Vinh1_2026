import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../services/database_service.dart';
import '../widgets/home/balance_summary_card.dart';
import '../widgets/home/feature_card.dart';
import '../widgets/home/insight_card.dart';
import '../widgets/home/money_stat_card.dart';
import '../widgets/home/recent_transaction_tile.dart';
import '../widgets/home/budget_management_sheet.dart';
import '../widgets/month_year_picker.dart';
import '../widgets/user_avatar.dart';
import 'edit_transaction_screen.dart';
import 'saving_goals_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final _formatter = NumberFormat('#,###', 'vi_VN');

  late int _currentMonth;
  late int _currentYear;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now().month;
    _currentYear = DateTime.now().year;
  }

  Future<void> _pickMonthYear() async {
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (_) => MonthYearPicker(
        initialMonth: _currentMonth,
        initialYear: _currentYear,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _currentMonth = result['month']!;
        _currentYear = result['year']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1015) : const Color(0xFFF3F4F6),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: DatabaseService.getBox().listenable(),
          builder: (context, Box<TransactionModel> box, _) {
            final transactions = DatabaseService.getFilteredTransactions(
              month: _currentMonth,
              year: _currentYear,
            );

            final summary = DatabaseService.getMonthSummary(
              transactions: transactions,
              month: _currentMonth,
              year: _currentYear,
            );

            final totalIncome = summary['totalIncome'] as double;
            final totalExpense = summary['totalExpense'] as double;
            final balance = summary['balance'] as double;
            final savingRate = summary['savingRate'] as double;
            final insightMessage = summary['insightMessage'] as String;
            final remainingBudget = summary['remainingBudget'] as double;
            final exceededCount = summary['exceededCount'] as int;
            final hasBudgets = summary['hasBudgets'] as bool;
            final categoryExpenses = summary['categoryExpenses'] as Map<String, double>;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
              children: [
                _buildTopBar(),
                const SizedBox(height: 24),
                ValueListenableBuilder(
                  valueListenable: DatabaseService.getSavingGoalsBoxListenable(),
                  builder: (context, box, _) {
                    final goals = DatabaseService.getSavingGoals();
                    double goalsAccumulated = 0.0;
                    for (var g in goals) {
                      if (g.isActiveIn(_currentMonth, _currentYear)) {
                        goalsAccumulated += g.currentAmount;
                      }
                    }
                    return _buildBalanceCard(balance, savingRate, goalsAccumulated);
                  },
                ),
                const SizedBox(height: 18),
                _buildStatRow(totalIncome, totalExpense),
                const SizedBox(height: 12),
                _buildFeatureRow(
                  hasBudgets,
                  exceededCount,
                  remainingBudget,
                  categoryExpenses,
                ),
                const SizedBox(height: 18),
                InsightCard(message: insightMessage),
                const SizedBox(height: 28),
                _buildRecentTransactionsHeader(),
                const SizedBox(height: 14),
                _buildTransactionList(transactions),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showBudgetManagementBottomSheet(Map<String, double> categoryExpenses) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF181B22) : const Color(0xFFF3F4F6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => BudgetManagementSheet(
        categoryExpenses: categoryExpenses,
        month: _currentMonth,
        year: _currentYear,
        onBudgetChanged: () {
          setState(() {});
        },
      ),
    );
  }


  Widget _buildTopBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sổ Thu Chi',
                style: TextStyle(
                  color: isDark ? const Color(0xFFEDE6DA) : const Color(0xFF172033),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        const UserAvatar(),
      ],
    );
  }

  Widget _buildBalanceCard(double balance, double savingRate, double goalsAccumulated) {
    final availableBalance = balance - goalsAccumulated;
    return BalanceSummaryCard(
      monthText: 'Tháng $_currentMonth/$_currentYear',
      availableText: '${_formatter.format(availableBalance)} đ',
      goalsAccumulatedText: '${_formatter.format(goalsAccumulated)} đ',
      totalAssetsText: '${_formatter.format(balance)} đ',
      savingRate: savingRate,
      onTapMonth: _pickMonthYear,
    );
  }

  Widget _buildStatRow(double totalIncome, double totalExpense) {
    return Row(
      children: [
        MoneyStatCard(
          title: 'Thu nhập',
          amount: '${_formatter.format(totalIncome)} đ',
          icon: Icons.trending_up,
          backgroundColor: const Color(0xFFFFDADD),
          iconColor: const Color(0xFFE94B5F),
        ),
        const SizedBox(width: 12),
        MoneyStatCard(
          title: 'Chi tiêu',
          amount: '${_formatter.format(totalExpense)} đ',
          icon: Icons.shopping_bag_outlined,
          backgroundColor: const Color(0xFFE6D4FF),
          iconColor: const Color(0xFF8B5CF6),
        ),
      ],
    );
  }

  Widget _buildFeatureRow(
    bool hasBudgets,
    int exceededCount,
    double remainingBudget,
    Map<String, double> categoryExpenses,
  ) {
    String budgetText;
    if (!hasBudgets) {
      budgetText = 'Chưa đặt';
    } else if (exceededCount > 0) {
      budgetText = 'Vượt $exceededCount d.mục!';
    } else {
      budgetText = 'Còn: ${_formatter.format(remainingBudget)} đ';
    }

    return Row(
      children: [
        FeatureCard(
          title: 'Ngân sách',
          subtitle: budgetText,
          icon: Icons.account_balance_wallet,
          backgroundColor: const Color(0xFFDFF5FF),
          iconColor: const Color(0xFF0EA5E9),
          onTap: () => _showBudgetManagementBottomSheet(categoryExpenses),
        ),
        const SizedBox(width: 12),
        ValueListenableBuilder(
          valueListenable: DatabaseService.getSavingGoalsBoxListenable(),
          builder: (context, box, _) {
            final allGoals = DatabaseService.getSavingGoals();
            final goals = allGoals.where((g) => g.isActiveIn(_currentMonth, _currentYear)).toList();
            String goalsSubtitle;
            if (goals.isEmpty) {
              goalsSubtitle = 'Chưa đặt';
            } else {
              double totalProgress = 0.0;
              for (var g in goals) {
                totalProgress += g.calculateProgress();
              }
              final avgProgress = (totalProgress / goals.length) * 100;
              goalsSubtitle = 'Đạt ${avgProgress.toStringAsFixed(0)}%';
            }

            return FeatureCard(
              title: 'Mục tiêu',
              subtitle: goalsSubtitle,
              icon: Icons.track_changes,
              backgroundColor: const Color(0xFFFFF1C7),
              iconColor: const Color(0xFFF97316),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SavingGoalsScreen(
                      month: _currentMonth,
                      year: _currentYear,
                    ),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      'Giao dịch gần đây',
      style: TextStyle(
        color: isDark ? const Color(0xFFEDE6DA) : const Color(0xFF172033),
        fontSize: 22,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionModel> transactions) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF181B22) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Không có giao dịch nào trong tháng này',
            style: TextStyle(color: Color(0xFF8E99AA)),
          ),
        ),
      );
    }

    return Column(
      children: transactions
          .take(6)
          .map(
            (tx) => RecentTransactionTile(
              transaction: tx,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditTransactionScreen(transaction: tx),
                  ),
                );
              },
              onDismissed: (_) async {
                await DatabaseService.deleteTransaction(tx.id);
              },
            ),
          )
          .toList(),
    );
  }
}
