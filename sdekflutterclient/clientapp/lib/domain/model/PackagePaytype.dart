import 'dart:convert';

import 'package:equatable/equatable.dart';

class PackagePaytype with EquatableMixin {
  final int? type_id;
  final String? type_name;

  PackagePaytype({
    this.type_id,
    this.type_name
  });
  
  @override
  List<Object?> get props => [
    type_id,
    type_name
  ];

  factory PackagePaytype.fromRawJson(String str) =>
      PackagePaytype.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory PackagePaytype.fromMap(Map<String, dynamic> json) => PackagePaytype(
    type_id: json['type_id'],
    type_name: json['type_name']
  );

  Map<String, dynamic> toMap() => {
    'type_id': type_id,
    'type_name': type_name
  };
}