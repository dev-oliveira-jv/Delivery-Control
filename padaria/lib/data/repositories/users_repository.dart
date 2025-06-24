import 'package:padaria/core/network/api_client.dart';
import '../models/user_model.dart';

class UsersRepository {
  Future<List<UserModel>> listUsersByPrivelege(int privelegeId) async {
    final response = await ApiClient.post("/list-users-by-privilege", {
      "privelegeId": privelegeId,
    });

    return (response as List<dynamic>)
        .map((userJson) => UserModel.fromJson(userJson))
        .toList();
  }
}
