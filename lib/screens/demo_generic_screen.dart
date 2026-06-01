import 'package:flutter/material.dart';
import '../services/generic_crud.dart';
import '../models/financial_models.dart';

class DemoGenericScreen extends StatefulWidget {
  const DemoGenericScreen({super.key});

  @override
  State<DemoGenericScreen> createState() => _DemoGenericScreenState();
}

class _DemoGenericScreenState extends State<DemoGenericScreen> {
  // Khởi tạo 2 kho lưu trữ CRUD riêng biệt từ Class Generic chung
  final GenericCRUD<FinancialTransaction> _transactionRepo = GenericCRUD();
  final GenericCRUD<SavingGoal> _savingGoalRepo = GenericCRUD();

  @override
  void initState() {
    super.initState();
    // Thêm dữ liệu mẫu cho Đối tượng 1 (Transactions)
    _transactionRepo.create(FinancialTransaction(id: "t1", title: "Mua giáo trình", amount: 1000000, category: "Giáo dục"));
    _transactionRepo.create(FinancialTransaction(id: "t2", title: "Ăn trưa", amount: 50000, category: "Đồ ăn"));

    // Thêm dữ liệu mẫu cho Đối tượng 2 (Saving Goals)
    _savingGoalRepo.create(SavingGoal(
      id: "g1", 
      goalName: "Mua Laptop mới", 
      currentAmount: 15000000, 
      targetAmount: 20000000, 
      deadline: DateTime.now().add(const Duration(days: 30)),
    ));
    _savingGoalRepo.create(SavingGoal(
      id: "g2", 
      goalName: "Quỹ khẩn cấp", 
      currentAmount: 5000000, 
      targetAmount: 5000000, 
      deadline: DateTime.now().subtract(const Duration(days: 2)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _transactionRepo.getAll();
    final savingGoals = _savingGoalRepo.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Tách Đối Tượng Generics'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- HÀNG 1: HIỂN THỊ ĐỐI TƯỢNG TRANSACTION ----------------
              const Row(
                children: [
                  Icon(Icons.compare_arrows, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('Đối tượng 1: Giao dịch (Thuộc tính đơn giản)', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final item = transactions[index];
                  return Card(
                    color: const Color(0xFF1E1E1E),
                    child: ListTile(
                      title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Danh mục: ${item.category}'),
                      // Sử dụng phương thức hoạt động getImpactAmount() trả về double
                      trailing: Text(
                        '${item.getImpactAmount().toStringAsFixed(0)} đ', 
                        style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16),

              // ---------------- HÀNG 2: HIỂN THỊ ĐỐI TƯỢNG SAVINGGOAL ----------------
              const Row(
                children: [
                  Icon(Icons.track_changes, color: Colors.tealAccent),
                  SizedBox(width: 8),
                  Text('Đối tượng 2: Mục tiêu (Thuộc tính phức tạp)', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: savingGoals.length,
                itemBuilder: (context, index) {
                  final goal = savingGoals[index];
                  final progress = goal.calculateProgress(); // Gọi phương thức hoạt động 1

                  return Card(
                    color: const Color(0xFF1E1E1E),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(goal.goalName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              // Sử dụng phương thức hoạt động 2 trả về một String trạng thái khác nhau
                              Text(goal.getGoalStatus(), style: const TextStyle(color: Colors.amber, fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Đã tích lũy: ${goal.currentAmount.toStringAsFixed(0)} / ${goal.targetAmount.toStringAsFixed(0)} đ',
                            style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          const SizedBox(height: 10),
                          // Hiển thị thanh tiến trình dựa trên thuộc tính kết hợp % hoạt động
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[800],
                            color: progress >= 1.0 ? Colors.green : Colors.tealAccent,
                            minHeight: 8,
                          ),
                          const SizedBox(height: 4),
                          Align(
  alignment: Alignment.centerRight,
  child: Text('${(progress * 100).toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12)),
)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}