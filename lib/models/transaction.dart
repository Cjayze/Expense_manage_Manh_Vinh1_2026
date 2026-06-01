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