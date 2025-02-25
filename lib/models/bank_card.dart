class BankCard {
  final int id;
  final String cardNumber;
  final bool isFrozen;
  final double balance;

  //get de balance
  double get getBalance => balance;

  BankCard({required this.id, required this.cardNumber, required this.isFrozen,required this.balance,});

  factory BankCard.fromJson(Map<String, dynamic> json) {
    return BankCard(
      id: json['id'],
      cardNumber: json['card_number'],
      isFrozen: json['is_frozen'] ?? false,
      balance: json['balance'].toDouble()?? 0.0,
    );
  }
}
