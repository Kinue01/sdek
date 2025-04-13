import 'dart:convert';

import 'package:clientapp/domain/model/WarehouseType.dart';
import 'package:equatable/equatable.dart';

class Warehouse with EquatableMixin {
  final int? warehouse_id;
  final String? warehouse_name;
  final String? warehouse_address;
  final WarehouseType? warehouse_type;

  Warehouse({
    this.warehouse_id,
    this.warehouse_name,
    this.warehouse_address,
    this.warehouse_type,
  });
  
  @override
  List<Object?> get props => [
    warehouse_id,
    warehouse_name,
    warehouse_address,
    warehouse_type,
  ];

  factory Warehouse.fromRawJson(String str) =>
      Warehouse.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory Warehouse.fromMap(Map<String, dynamic> json) => Warehouse(
    warehouse_id: json['warehouse_id'],
    warehouse_name: json['warehouse_name'],
    warehouse_address: json['warehouse_address'],
    warehouse_type: WarehouseType.fromMap(json['warehouse_type']),
  );

  Map<String, dynamic> toMap() => {
    'warehouse_id': warehouse_id,
    'warehouse_name': warehouse_name,
    'warehouse_address': warehouse_address,
    'warehouse_type': warehouse_type?.toMap(),
  };
}