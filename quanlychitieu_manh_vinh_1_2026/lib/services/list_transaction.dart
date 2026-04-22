import '../models/transaction.dart';

class ListTransaction {
  List<Transaction> list = [];

  void create(Transaction t) {
    list.add(t);
  }

  List<Transaction> read() {
    return list;
  }

  void update(int id, String newTitle, double newAmount) {
    for (var t in list) {
      if (t.id == id) {
        t.title = newTitle;
        t.amount = newAmount;
      }
    }
  }

  void delete(int id) {
    list.removeWhere((t) => t.id == id);
  }
}