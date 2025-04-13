import 'dart:convert';

import 'package:equatable/equatable.dart';

class WarehouseType with EquatableMixin {
  final int? type_id;
  final String? type_name;
  final int? type_small_quantity;
  final int? type_med_quantity;
  final int? type_huge_quantity;

  WarehouseType({
    this.type_id,
    this.type_name,
    this.type_small_quantity,
    this.type_med_quantity,
    this.type_huge_quantity
  });
  
  @override
  List<Object?> get props => [
    type_id,
    type_name,
    type_small_quantity,
    type_med_quantity,
    type_huge_quantity
  ];

  factory WarehouseType.fromRawJson(String str) =>
      WarehouseType.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory WarehouseType.fromMap(Map<String, dynamic> json) => WarehouseType(
    type_id: json['type_id'],
    type_name: json['type_name'],
    type_small_quantity: json['type_small_quantity'],
    type_med_quantity: json['type_med_quantity'],
    type_huge_quantity: json['type_huge_quantity'],
  );

  Map<String, dynamic> toMap() => {
    'type_id': type_id,
    'type_name': type_name,
    'type_small_quantity': type_small_quantity,
    'type_med_quantity': type_med_quantity,
    'type_huge_quantity': type_huge_quantity,
  };
}