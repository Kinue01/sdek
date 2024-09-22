import 'dart:convert';

import 'package:clientapp/domain/model/User.dart';
import 'package:equatable/equatable.dart';

class Client with EquatableMixin {
  final int? client_id;
  final String? client_lastname;
  final String? client_firstname;
  final String? client_middlename;
  final User client_user;

  Client({
    this.client_id,
    this.client_lastname,
    this.client_firstname,
    this.client_middlename,
    required this.client_user
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    client_id,
    client_lastname,
    client_firstname,
    client_middlename,
    client_user
  ];

  factory Client.fromRawJson(String str) =>
      Client.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory Client.fromMap(Map<String, dynamic> json) => Client(
    client_id: json['client_id'],
    client_lastname: json['client_lastname'],
    client_firstname: json['client_firstname'],
    client_middlename: json['client_middlename'],
    client_user: User.fromRawJson(json['client_user']),
  );

  Map<String, dynamic> toMap() => {
    'client_id': client_id,
    'client_lastname': client_lastname,
    'client_firstname': client_firstname,
    'client_middlename': client_middlename,
    'client_user': client_user.toRawJson()
  };
}