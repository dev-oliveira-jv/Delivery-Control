import 'dart:io';

import 'package:flutter/material.dart';

class UserModel {
  final String? objectId;
  final String? username;
  final String? email;
  final String? sessionToken;
  final Map<String, dynamic>? privelege;
  final int privelegeId;
  final double limiteCredito;
  final File? image;

  UserModel(
      {required this.objectId,
      required this.username,
      required this.email,
      required this.sessionToken,
      required this.privelege,
      required this.privelegeId,
      this.image = null,
      this.limiteCredito = 0.0});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final privelegeMap = json['privelege'] as Map<String, dynamic>?;
    return UserModel(
      objectId: json['objectId'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      sessionToken: json['sessionToken'] as String?,
      privelege: privelegeMap,
      privelegeId: int.tryParse(privelegeMap?['number']?.toString() ?? '') ?? 3,
      limiteCredito: (json['limite'] is int || json['limite'] is double)
          ? (json['limite'] as num).toDouble()
          : 0.0,
    );
  }

  get obejectId => null;

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'username': username,
      'email': email,
      'sessionToken': sessionToken,
      'privelege': privelege,
      'privelegeId': privelegeId,
      'limite': limiteCredito,
    };
  }

  bool temLimiteDisponivel(double valorPedido) {
    return limiteCredito >= valorPedido;
  }
}
