import 'dart:ffi';
import 'dart:io';

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
    final response = await ApiClient.post('/register', {
      'username': username,
      'email': email,
      'password': password,
      'limite': limite,
      'privelege': privelege,
      'phone': phone,
      'image': image.path,
      'addres': addres,
      'location': location
    });
    return UserModel.fromJson(response);
  }

  Future<bool> resetPassword(String email) async {
    final response = await ApiClient.post('/reset-password', {
      'email': email,
    });
    return response['sucess'] ?? false;
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
    final response = await ApiClient.post('/update', {
      'objectId': objectId,
      'username': username,
      'email': email,
      'password': password,
      'limite': limite,
      'privelege': privelege,
      'phone': phone,
      'image': image.path,
      'addres': addres,
      'location': location
    });
    return UserModel.fromJson(response);
  }

  Future<UserModel> updateUserLimit(
      String objectId, double limiteCredito) async {
    final response = await ApiClient.post(
        '/update-user-limit', {'objectId': objectId, 'limite': limiteCredito});
    return UserModel.fromJson(response);
  }
}
