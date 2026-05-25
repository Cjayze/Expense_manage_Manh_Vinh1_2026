import 'package:flutter/material.dart';
import '../models/expense_record.dart';
import '../models/income_record.dart';
import '../services/generic_crud.dart';
import '../widgets/common_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GenericCrud<ExpenseRecord> expenseRepo = GenericCrud<ExpenseRecord>();
  final GenericCrud<IncomeRecord> incomeRepo = GenericCrud<IncomeRecord>();

  double get totalExpense {
    return expenseRepo
        .getAll()
        .fold(0, (sum, item) => sum + item.amount);
  }

  double get totalIncome {
    return incomeRepo
        .getAll()
        .fold(0, (sum, item) => sum + item.gross());
  }

  @override
  void initState() {
    super.initState();
    expenseRepo.create(
      ExpenseRecord(
        id: 1,
        title: 'An sang',
        category: 'An uong',
        amount: 30,
        date: DateTime(2026, 4, 10),
      ),
    );
    expenseRepo.create(
      ExpenseRecord(
        id: 2,
        title: 'Game',
        category: 'Giai tri',
        amount: 50,
        date: DateTime(2026, 4, 11),
      ),
    );
    expenseRepo.update(
      ExpenseRecord(
        id: 2,
        title: 'Game online',
        category: 'Giai tri',
        amount: 55,
        date: DateTime(2026, 4, 11),
      ),
    );

    incomeRepo.create(
      IncomeRecord(
        id: 1,
        source: 'Luong part-time',
        hours: 12,
        rate: 40,
        isBonus: false,
      ),
    );
    incomeRepo.create(
      IncomeRecord(
        id: 2,
        source: 'Thuong du an',
        hours: 5,
        rate: 60,
        isBonus: true,
      ),
    );
    incomeRepo.delete(99);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CommonHeader(title: 'Home'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tong chi tieu: $totalExpense'),
                  Text('Tong thu nhap: $totalIncome'),
                  const SizedBox(height: 20),
                  Text(
                    'Danh sach chi tieu',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      for (final item in expenseRepo.getAll())
                        Card(
                          child: ListTile(
                            title: Text(item.title),
                            subtitle: Text(
                              '${item.category} | ${_formatDate(item.date)}',
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Tien: ${item.amount}k'),
                                Text(
                                  'Sau thue: ${item.amountWithTax(0.1).toStringAsFixed(1)}k',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Danh sach thu nhap',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      for (final item in incomeRepo.getAll())
                        Card(
                          child: ListTile(
                            title: Text(item.source),
                            subtitle: Text(
                              'Gio: ${item.hours} | Gio cong: ${item.rate}k',
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(item.isBonus ? 'Co thuong' : 'Khong thuong'),
                                Text(
                                  'Tong: ${item.gross().toStringAsFixed(1)}k',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
