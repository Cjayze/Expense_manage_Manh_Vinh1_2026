import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/report_service.dart';
import '../widgets/user_avatar.dart';
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool isAnalysisTab = true;

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Báo cáo"),
      actions: const [
        UserAvatar(),
      ],
    ),
    body: SingleChildScrollView(
      child: _buildAnalysisContent(),
    ),
  );
}
  Widget _buildAnalysisContent() {
  final theme = Theme.of(context);

  final now = DateTime.now();

  final income =
      ReportService.getTotalIncome(
    now.month,
    now.year,
  );

  final expense =
      ReportService.getTotalExpense(
    now.month,
    now.year,
  );

  final balance =
      income - expense;

  final topCategory =
      ReportService.getTopExpenseCategory(
    now.month,
    now.year,
  );

  final largestExpense =
      ReportService.getLargestExpense(
    now.month,
    now.year,
  );

  final formatter =
      NumberFormat(
        "#,###",
        "vi_VN",
      );

  return _buildCardWrapper(
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          "Báo cáo tháng ${now.month}/${now.year}",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          "Thu nhập: ${formatter.format(income)} đ",
          style: const TextStyle(
            color: Colors.green,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "Chi tiêu: ${formatter.format(expense)} đ",
          style: const TextStyle(
            color: Colors.red,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "Số dư: ${formatter.format(balance)} đ",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
          ),
        ),

        const Divider(),

        Text(
          "Danh mục chi nhiều nhất",
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),

        Text(
          topCategory,
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 18,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          "Khoản chi lớn nhất",
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),

        Text(
          "${formatter.format(largestExpense)} đ",
          style: const TextStyle(
            color: Colors.amber,
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}

  Widget _buildCardWrapper({required Widget child}) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }
}
