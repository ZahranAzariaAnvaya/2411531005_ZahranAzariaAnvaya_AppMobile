class TransactionModel {
  final int? id;
  final int userId;
  final String title;
  final int amount;
  final bool isIncome;
  final String category;
  final DateTime date;

  const TransactionModel({
    this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.category,
    required this.date,
  });

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'user_id': userId,
    'title': title,
    'amount': amount,
    'is_income': isIncome ? 1 : 0,
    'category': category,
    'date': date.toIso8601String(),
  };

  factory TransactionModel.fromMap(Map<String, Object?> map) =>
      TransactionModel(
        id: map['id'] as int,
        userId: map['user_id'] as int,
        title: map['title'] as String,
        amount: map['amount'] as int,
        isIncome: (map['is_income'] as int) == 1,
        category: map['category'] as String,
        date: DateTime.parse(map['date'] as String),
      );
}
