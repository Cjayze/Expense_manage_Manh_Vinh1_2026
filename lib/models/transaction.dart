import 'package:hive_flutter/hive_flutter.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String type; // "Chi tiêu" hoặc "Thu nhập"
  
  @HiveField(2)
  final String categoryName;
  
  @HiveField(3)
  final int categoryIconCode;
  
  @HiveField(4)
  final int categoryColorValue;
  
  @HiveField(5)
  final double amount;
  
  @HiveField(6)
  final String note;
  
  @HiveField(7)
  final DateTime dateTime;

  TransactionModel({
    required this.id,
    required this.type,
    required this.categoryName,
    required this.categoryIconCode,
    required this.categoryColorValue,
    required this.amount,
    required this.note,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'categoryName': categoryName,
      'categoryIconCode': categoryIconCode,
      'categoryColorValue': categoryColorValue,
      'amount': amount,
      'note': note,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  static TransactionModel fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      type: map['type'] as String,
      categoryName: map['categoryName'] as String,
      categoryIconCode: map['categoryIconCode'] as int,
      categoryColorValue: map['categoryColorValue'] as int,
      amount: (map['amount'] as num).toDouble(),
      note: map['note'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
    );
  }
}

class DatabaseService {
  static const String _boxName = "transactions_box";

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }
    await Hive.openBox<TransactionModel>(_boxName);
  }

  static Box<TransactionModel> getBox() => Hive.box<TransactionModel>(_boxName);

  static Future<void> addTransaction(TransactionModel tx) async {
    final box = getBox();
    await box.put(tx.id, tx);
  }

  static Future<void> deleteTransaction(String id) async {
    final box = getBox();
    await box.delete(id);
  }
}