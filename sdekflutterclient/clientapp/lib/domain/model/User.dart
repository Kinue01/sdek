import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'Role.dart';

class User with EquatableMixin {
  final String? user_id;
  final String? user_login;
  final String? user_password;
  final String? user_email;
  final String? user_phone;
  final String? user_access_token;
  final Role user_role;

  User({
    this.user_id,
    this.user_login,
    this.user_password,
    this.user_email,
    this.user_phone,
    this.user_access_token,
    required this.user_role
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    user_id,
    user_login,
    user_password,
    user_email,
    user_phone,
    user_access_token,
    user_role
  ];

  factory User.fromRawJson(String str) =>
      User.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory User.fromMap(Map<String, dynamic> json) => User(
    user_id: json['user_id'],
    user_login: json['user_login'],
    user_password: json['user_password'],
    user_email: json['user_email'],
    user_phone: json['user_phone'],
    user_access_token: json['user_access_token'],
    user_role: Role.fromRawJson(json['user_role']),
  );

  Map<String, dynamic> toMap() => {
    'user_id': user_id,
    'user_login': user_login,
    'user_password': user_password,
    'user_email': user_email,
    'user_phone': user_phone,
    'user_access_token': user_access_token,
    'user_role_id': user_role.toRawJson(),
  };
}