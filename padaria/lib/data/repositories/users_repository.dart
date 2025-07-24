import 'package:padaria/core/network/api_client.dart';
import '../models/user_model.dart';

class UsersRepository {
  Future<List<UserModel>> listUsers() async {
    final response = await ApiClient.postList("/list-users", {});
    print("Usuários recebidos: $response");
    return response.map((json) => UserModel.fromJson(json)).toList();
  }
}
