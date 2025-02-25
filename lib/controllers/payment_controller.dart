import '../services/api_service.dart';
import '../models/payment.dart';

class PaymentController {
  final ApiService _apiService = ApiService();

  Future<Payment> processPayment(int userId, double amount, String cardNumber) async {
    return await _apiService.processPayment(userId, amount, cardNumber);
  }
}