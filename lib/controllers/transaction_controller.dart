
import '../services/api_service.dart';
import '../models/transaction.dart';

class TransactionController {
  final ApiService _apiService = ApiService();

  Future<List<Transaction>> getTransactions(int userId) async {
    return await _apiService.getTransactions(userId);
  }



}