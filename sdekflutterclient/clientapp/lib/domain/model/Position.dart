import 'dart:convert';

import 'package:equatable/equatable.dart';

class Position with EquatableMixin {

  final int? position_id;
  final String? position_name;
  final int? position_base_pay;

  Position({
    this.position_id,
    this.position_name,
    this.position_base_pay
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    position_id,
    position_name,
    position_base_pay
  ];

  factory Position.fromRawJson(String str) =>
      Position.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory Position.fromMap(Map<String, dynamic> json) => Position(
    position_id: json['position_id'],
    position_name: json['position_name'],
    position_base_pay: json['position_base_pay'],
  );

  Map<String, dynamic> toMap() => {
    'position_id': position_id,
    'position_name': position_name,
    'position_base_pay': position_base_pay,
  };
}