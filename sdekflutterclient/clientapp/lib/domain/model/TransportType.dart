import 'dart:convert';

import 'package:equatable/equatable.dart';

class TransportType with EquatableMixin {

  final int? type_id;
  final String? type_name;

  TransportType({
    this.type_id,
    this.type_name,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    type_id,
    type_name,
  ];

  factory TransportType.fromRawJson(String str) =>
      TransportType.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory TransportType.fromMap(Map<String, dynamic> json) => TransportType(
    type_id: json['type_id'],
    type_name: json['type_name'],
  );

  Map<String, dynamic> toMap() => {
    'type_id': type_id,
    'type_name': type_name,
  };
}