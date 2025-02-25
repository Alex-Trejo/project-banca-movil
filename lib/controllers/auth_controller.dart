import '../services/api_service.dart';
import '../models/user.dart';

class AuthController {
  final ApiService _apiService = ApiService();

  Future<User> register(String name, String email, String password) async {
    return await _apiService.register(name, email, password);
  }

  Future<User> login(String email, String password) async {
    return await _apiService.login(email, password);
  }
  
}