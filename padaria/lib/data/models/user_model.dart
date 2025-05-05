class UserModel {
  final String? objectId;
  final String? username;
  final String? email;
  final String? sessionToken;
  final Map<String, dynamic>? privelege;
  final int privelegeId;

  UserModel(
      {required this.objectId,
      required this.username,
      required this.email,
      required this.sessionToken,
      required this.privelege,
      required this.privelegeId});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final privelegeMap = json['privelege'] as Map<String, dynamic>?;
    return UserModel(
        objectId: json['objectId'] as String?,
        username: json['username'] as String?,
        email: json['email'] as String?,
        sessionToken: json['sessionToken'] as String?,
        privelege: privelegeMap,
        privelegeId: privelegeMap?['number']);
  }
}
