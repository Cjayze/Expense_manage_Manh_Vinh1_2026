import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_manager.dart';
import '../widgets/common_header.dart';

class MyGeneric<T> {
  T obj;

  MyGeneric(this.obj);

  void printData() {
    if (obj is List<Map<String, String>>) {
      for (var item in obj as List<Map<String, String>>) {
        print('${item['studentID']} - ${item['fullname']}');
      }
    } else {
      print(obj);
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> students = [
    {'studentID': 's123456', 'fullname': 'Nguyen Thi B'},
    {'studentID': 's345672', 'fullname': 'Nguyen Van D'},
    {'studentID': 's923333', 'fullname': 'Tran Thi Van'},
  ];
  final manager = CategoryManager();

  String userName = 'Do Xuan Vinh';
  double totalMoney = 5000;
  bool isSaving = true;

  final List<Map<String, dynamic>> expenses = [
    {"name": "An sang", "amount": 30, "date": DateTime(2026, 4, 10)},
    {"name": "Game", "amount": 50, "date": DateTime(2026, 4, 11)},
    {"name": "Mua sam", "amount": 100, "date": DateTime(2026, 4, 12)},
  ];

  final List<Map<String, dynamic>> wallets = [
    {'id': 1, 'name': 'Vi tien mat'},
    {'id': 2, 'name': 'Ngan hang'},
    {'id': 3, 'name': 'Momo'},
  ];

  double get totalSpent {
    double sum = 0;
    for (var item in expenses) {
      sum += item["amount"];
    }
    return sum;
  }

  @override
  void initState() {
    super.initState();

    final genericObj = MyGeneric<List<Map<String, String>>>(students);
    genericObj.printData();

    manager.createCategory(
      Category(id: 1, name: "An uong", icon: "An uong", type: "expense"),
    );
    manager.createCategory(
      Category(id: 2, name: "Luong", icon: "Luong", type: "income"),
    );
    manager.createCategory(
      Category(id: 3, name: "Thuong", icon: "Thuong", type: "income"),
    );

    print("Catehory list");
    for (var c in manager.getAllCategories()) {
      c.display();
    }

    manager.updateCategory(1, name: "An uong hang ngay", icon: "Food");

    print("Update ID=1");
    for (var c in manager.getAllCategories()) {
      c.display();
    }

    manager.deleteCategory(2);
    print("Delete ID=2");
    for (var c in manager.getAllCategories()) {
      c.display();
    }
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
                  Text('User: $userName'),
                  Text('Tong tien: $totalMoney'),
                  Text('Da chi: $totalSpent'),
                  Text(isSaving ? 'Dang tiet kiem' : 'Tieu qua tay'),
                  const SizedBox(height: 20),
                  const Text('Danh sach chi tieu:'),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Expanded(flex: 3, child: Text('Ten')),
                      Expanded(
                        flex: 2,
                        child: Text('Tien', textAlign: TextAlign.center),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('Ngay', textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      for (var item in expenses)
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text(item["name"])),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${item["amount"]}k',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${item["date"].day}/${item["date"].month}',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: expenses.map((item) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Map: ${item["name"]}'),
                          Text('${item["amount"]}k'),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Danh sach vi:'),
                  const SizedBox(height: 6),
                  Column(
                    children: [
                      for (var w in wallets)
                        Row(
                          children: [
                            Expanded(flex: 1, child: Text('${w["id"]}')),
                            Expanded(
                              flex: 3,
                              child: Text(w["name"], textAlign: TextAlign.right),
                            ),
                          ],
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
