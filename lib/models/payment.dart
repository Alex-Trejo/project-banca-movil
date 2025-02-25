class Payment {
  final int id;
  final double amount;
  final String cardNumber;
  final int userId; // Agregar user_id
  final String timestamp; // Agregar timestamp

  Payment({
    required this.id,
    required this.amount,
    required this.cardNumber,
    required this.userId,
    required this.timestamp, // Añadir el timestamp
  });

  // Ajuste del factory para solo usar el payment_id de la respuesta
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      amount: json['amount']?.toDouble() ?? 0.0, // Asegúrate de tener un valor por defecto si no se recibe
      cardNumber: json['card_number'] ?? "",  // Asegúrate de manejar el valor nulo
      userId: json['user_id'] ?? 0,  // Asegúrate de manejar el valor nulo
      timestamp: json['timestamp'] ?? "",  // Asegúrate de manejar el valor nulo
    );
  }
}
