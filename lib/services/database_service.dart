import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction.dart';
import 'auth_service.dart';

class DatabaseService {
  static const String _boxName = 'transactions_box';

  static Box<TransactionModel> getBox() {
    return Hive.box<TransactionModel>(_boxName);
  }

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(
        TransactionModelAdapter(),
      );
    }

    await Hive.openBox<TransactionModel>(
      _boxName,
    );
  }

  static Future<void> addTransaction(
  TransactionModel transaction,
) async {
  try {
    print("UID hien tai: ${AuthService.uid}");
    print("Email: ${AuthService.currentEmail}");

    final box = getBox();

    await box.put(transaction.id, transaction);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService.uid)
        .collection('transactions')
        .doc(transaction.id)
        .set({
      'id': transaction.id,
      'type': transaction.type,
      'categoryName': transaction.categoryName,
      'categoryIconCode': transaction.categoryIconCode,
      'categoryColorValue': transaction.categoryColorValue,
      'amount': transaction.amount,
      'note': transaction.note,
      'dateTime': transaction.dateTime.toIso8601String(),
    });

    print("ĐÃ LƯU FIRESTORE THÀNH CÔNG");
  } catch (e) {
    print("LỖI FIRESTORE:");
    print(e);
  }
}

  static Future<void> deleteTransaction(
    String id,
  ) async {
    final box = getBox();

    await box.delete(id);

    if (AuthService.uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService.uid)
        .collection('transactions')
        .doc(id)
        .delete();
  }

  static Future<void> syncFromFirebase()
      async {
    if (AuthService.uid == null) return;

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(AuthService.uid)
              .collection('transactions')
              .get();

      final box = getBox();

      await box.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();

        final model = TransactionModel(
          id: data['id'],
          type: data['type'],
          categoryName:
              data['categoryName'],
          categoryIconCode:
              data['categoryIconCode'],
          categoryColorValue:
              data['categoryColorValue'],
          amount:
              (data['amount'] as num)
                  .toDouble(),
          note: data['note'],
          dateTime: DateTime.parse(
            data['dateTime'],
          ),
        );

        await box.put(
          model.id,
          model,
        );
      }
    } catch (e) {
      print(
        'Firebase Sync Error: $e',
      );
    }
  }
}