import '../services/api_service.dart';
import '../models/bank_card.dart';

class CardController {
  final ApiService _apiService = ApiService();

  Future<BankCard> addCard(int userId, String cardNumber, double balance) async {
    return await _apiService.addCard(userId, cardNumber, balance);
  }

  Future<void> freezeCard(int cardId) async {
    await _apiService.freezeCard(cardId);
  }
}