import 'dart:ffi';
import 'dart:io';

import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

class AuthService {
  final AuthRepository _authRepository = AuthRepository();

  Future<UserModel> login(String username, String password) async {
    return await _authRepository.login(username, password);
  }

  Future<UserModel> register(
      String username,
      String email,
      String password,
      Double limite,
      String privelege,
      int phone,
      File image,
      String addres,
      String location) async {
    return await _authRepository.register(username, email, password, limite,
        privelege, phone, image, addres, location);
  }

  Future<bool> resetPassword(String email) async {
    return await _authRepository.resetPassword(email);
  }

  Future<UserModel> updateUser(
      String objectId,
      String username,
      String email,
      String password,
      Double limite,
      String privelege,
      int phone,
      File image,
      String addres,
      String location) async {
    return await _authRepository.updateUser(objectId, username, email, password,
        limite, privelege, phone, image, addres, location);
  }

  Future<UserModel> updateUserLimit(
      String objectId, double limiteCredito) async {
    return await _authRepository.updateUserLimit(objectId, limiteCredito);
  }

  bool verificarLimiteDisponivel(UserModel user, double valorPedido) {
    return user.temLimiteDisponivel(valorPedido);
  }
}
