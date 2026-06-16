import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart' hide DatabaseService;
import '../services/database_service.dart';
import '../widgets/home/balance_summary_card.dart';
import '../widgets/home/feature_card.dart';
import '../widgets/home/insight_card.dart';
import '../widgets/home/money_stat_card.dart';
import '../widgets/home/recent_transaction_tile.dart';
import '../widgets/month_year_picker.dart';
import '../widgets/user_avatar.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFF0D1015),
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
            );

            final totalIncome = summary['totalIncome'] as double;
            final totalExpense = summary['totalExpense'] as double;
            final balance = summary['balance'] as double;
            final savingRate = summary['savingRate'] as double;
            final insightMessage = summary['insightMessage'] as String;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
              children: [
                _buildTopBar(),
                const SizedBox(height: 24),
                _buildBalanceCard(balance, savingRate),
                const SizedBox(height: 18),
                _buildStatRow(totalIncome, totalExpense),
                const SizedBox(height: 12),
                _buildFeatureRow(),
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



  Widget _buildTopBar() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Sổ Thu Chi',
                style: TextStyle(
                  color: Color(0xFFEDE6DA),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
        const UserAvatar(),
      ],
    );
  }

  Widget _buildBalanceCard(double balance, double savingRate) {
    return BalanceSummaryCard(
      monthText: 'Tháng $_currentMonth/$_currentYear',
      balanceText: '${_formatter.format(balance)} đ',
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

  Widget _buildFeatureRow() {
    return Row(
      children: const [
        FeatureCard(
          title: 'Ngân sách',
          subtitle: 'Theo dõi',
          icon: Icons.account_balance_wallet,
          backgroundColor: Color(0xFFDFF5FF),
          iconColor: Color(0xFF0EA5E9),
        ),
        SizedBox(width: 12),
        FeatureCard(
          title: 'Mục tiêu',
          subtitle: 'Tiết kiệm',
          icon: Icons.track_changes,
          backgroundColor: Color(0xFFFFF1C7),
          iconColor: Color(0xFFF97316),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsHeader() {
    return const Text(
      'Giao dịch gần đây',
      style: TextStyle(
        color: Color(0xFFEDE6DA),
        fontSize: 22,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF181B22),
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
              onTap: () {},
              onDismissed: (_) async {
                await DatabaseService.deleteTransaction(tx.id);
              },
            ),
          )
          .toList(),
    );
  }
}
