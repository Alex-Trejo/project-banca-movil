import 'dart:convert';
import '../models/user.dart';
import '../models/bank_card.dart';
import '../models/payment.dart';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class ApiService {
  static const String baseUrl = 'https://banca-movil-api.onrender.com'; // Se cambió a HTTPS por seguridad

  Future<User> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201 && response.body.isNotEmpty) {
      return login(email, password); // Inicia sesión automáticamente tras registro
    }
    throw Exception('Error al registrar: ${response.statusCode} - ${response.body}');
  }

  Future<List<BankCard>> getCards(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/cards/$userId'));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => BankCard.fromJson(item)).toList();
    }
    throw Exception('Error al obtener tarjetas: ${response.statusCode} - ${response.body}');
  }

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final json = jsonDecode(response.body);
      return User.fromJson(json['user']);
    }
    throw Exception('Error al iniciar sesión: ${response.statusCode} - ${response.body}');
  }

 Future<BankCard> addCard(int userId, String cardNumber, double balance) async {
  final response = await http.post(
    Uri.parse('$baseUrl/cards'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'card_number': cardNumber, 'balance': balance}),
  );

  if (response.statusCode == 201) {
    final responseData = jsonDecode(response.body);

    return BankCard(
      id: responseData['id'],
      cardNumber: cardNumber, // Usamos el número enviado porque el backend no lo devuelve
      balance: responseData['balance'],
      isFrozen: false, // Valor predeterminado ya que el backend no lo envía
    );
  }

  throw Exception('Error al agregar tarjeta: ${response.statusCode} - ${response.body}');
}


  Future<void> freezeCard(int cardId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cards/$cardId/freeze'),
      headers: {'Content-Type': 'application/json'}, // Se agregó el encabezado
    );

    if (response.statusCode != 200) {
      throw Exception('Error al congelar tarjeta: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Payment> processPayment(int userId, double amount, String cardNumber) async {
  final response = await http.post(
    Uri.parse('$baseUrl/payments'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'amount': amount, 'card_number': cardNumber}),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);

    return Payment(
      id: responseData['payment_id'],  // ID del pago desde el backend
      amount: amount,                  // Monto enviado
      cardNumber: cardNumber,           // Tarjeta utilizada
      userId: userId,                   // Agregamos el userId
      timestamp: DateTime.now().toString(),  // Timestamp actual
    );
  }

  throw Exception('Error al procesar pago: ${response.statusCode} - ${response.body}');
}



  Future<List<Transaction>> getTransactions(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/transactions/$userId'));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<dynamic> data = jsonDecode(response.body)['transactions'];
      return data.map((item) => Transaction.fromJson(item)).toList();
    }
    throw Exception('Error al obtener transacciones: ${response.statusCode} - ${response.body}');
  }
}