import '../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRepository {
  Future<UserModel> login(String username, String password) async {
    final response = await ApiClient.post('/login', {
      'username': username,
      'password': password,
    });
    return UserModel.fromJson(response);
  }
}
