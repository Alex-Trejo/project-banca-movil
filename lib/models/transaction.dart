class Transaction {
  final int id;
  final double amount;
  final String details;
  final String timestamp; // Timestamp en formato ISO 8601

  Transaction({required this.id, required this.amount, required this.details, required this.timestamp});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'].toDouble(),  // Convertir a double
      details: json['details'],  // Detalles de la transacción
      timestamp: json['timestamp'],  // Timestamp en formato ISO 8601
    );
  }
}