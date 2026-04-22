import 'package:flutter/material.dart';
import 'services/category_manager.dart';
import 'models/category.dart';

void main() {
  runApp(const MyApp());
}

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Quan li chi tieu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Quản lý chi tiêu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //bai thuc hanh so 3
  final List<Map<String, String>> students = [
    {'studentID': 's123456', 'fullname': 'Nguyen Thi B'},
    {'studentID': 's345672', 'fullname': 'Nguyen Van D'},
    {'studentID': 's923333', 'fullname': 'Tran Thi Van'},
  ];
  final manager = CategoryManager();

  //bai thuc hanh so 2
  //1. Biến
  String userName = "Đỗ Xuân Vinh";
  double totalMoney = 5000;
  bool isSaving = true;

  //2. Collection (chi tiêu)
  final List<Map<String, dynamic>> expenses = [
    {"name": "Ăn sáng", "amount": 30, "date": DateTime(2026, 4, 10)},
    {"name": "Game", "amount": 50, "date": DateTime(2026, 4, 11)},
    {"name": "Mua sắm", "amount": 100, "date": DateTime(2026, 4, 12)},
  ];

  //3. Collection (ví tiền)
  final List<Map<String, dynamic>> wallets = [
    {'id': 1, 'name': 'Ví tiền mặt'},
    {'id': 2, 'name': 'Ngân hàng'},
    {'id': 3, 'name': 'Momo'},
  ];

  // Tính tổng tiền đã chi
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

    // bai thuc hanh so 3
    final genericObj = MyGeneric<List<Map<String, String>>>(students);
    genericObj.printData();
      // create
    manager.createCategory(
      Category(id: 1, name: "Ăn uống", icon: "Ăn uống", type: "expense"),
    );

    manager.createCategory(
      Category(id: 2, name: "Lương", icon: "Lương", type: "income"),
    );
    
    manager.createCategory(
      Category(id: 3, name: "Thưởng", icon: "Thưởng", type: "income")
    );

      // read 
    print("Catehory list");
    for (var c in manager.getAllCategories()) {
      c.display();
    }

      // update
    manager.updateCategory(1, name: "Ăn uống hàng ngày", icon: "Food");

    print("Update ID=1");
    for (var c in manager.getAllCategories()) {
      c.display();
    }

      // delete
    manager.deleteCategory(2);
    print("Delete ID=2");
    for (var c in manager.getAllCategories()) {
      c.display();
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //4. Hiển thị biến
            Text('User: $userName'),
            Text('Tổng tiền: $totalMoney'),
            Text('Đã chi: $totalSpent'),
            Text(isSaving ? 'Đang tiết kiệm' : 'Tiêu quá tay'),

            const SizedBox(height: 20),

            //5. Hiển thị collection (expenses)
            const Text('Danh sách chi tiêu:'),

            // Header
            Row(
              children: const [
                Expanded(flex: 3, child: Text('Tên')),
                Expanded(flex: 2, child: Text('Tiền', textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('Ngày', textAlign: TextAlign.right)),
              ],
            ),

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

            const SizedBox(height: 20),

            //Hiển thị bằng map()
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

            const SizedBox(height: 20),

            //7. Hiển thị collection (wallets)
            const Text('Danh sách ví:'),

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
    );
  }
}