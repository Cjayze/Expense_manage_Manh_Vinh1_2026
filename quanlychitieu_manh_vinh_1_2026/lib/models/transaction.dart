class Transaction {
  int id;
  String title;
  double amount;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
  });

  void display() {
    print("ID: $id - $title - $amount");
  }
}