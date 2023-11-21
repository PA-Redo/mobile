import 'dart:convert';

import 'package:pa_mobile/core/utils/encode.dart';

class LoginRequestDto extends Encodable {

  LoginRequestDto({required this.username, required this.password, required this.firebaseToken});

  String username;
  String password;
  String firebaseToken;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'firebaseToken': firebaseToken,
    };
  }

  @override
  String encode() {
    return jsonEncode(toJson());
  }
}
