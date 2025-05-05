import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

class AuthService {
  final AuthRepository _authRepository = AuthRepository();

  Future<UserModel> login(String username, String password) async {
    return await _authRepository.login(username, password);
  }
}
