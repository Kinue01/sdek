import 'dart:convert';

import 'package:equatable/equatable.dart';

class Role with EquatableMixin {

  final int? role_id;
  final String? role_name;

  Role({
    this.role_id,
    this.role_name
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    role_id,
    role_name
  ];

  factory Role.fromRawJson(String str) =>
      Role.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory Role.fromMap(Map<String, dynamic> json) => Role(
    role_id: json['role_id'],
    role_name: json['role_name'],
  );

  Map<String, dynamic> toMap() => {
    'role_id': role_id,
    'role_name': role_name,
  };
}