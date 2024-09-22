import 'dart:convert';

import 'package:equatable/equatable.dart';

class PackageType with EquatableMixin {
  final int? type_id;
  final String? type_name;
  final int? type_length;
  final int? type_width;
  final int? type_height;
  final int? type_weight;

  PackageType({
    this.type_id,
    this.type_name,
    this.type_length,
    this.type_width,
    this.type_height,
    this.type_weight
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    type_id,
    type_name,
    type_length,
    type_width,
    type_height,
    type_weight
  ];

  factory PackageType.fromRawJson(String str) =>
      PackageType.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory PackageType.fromMap(Map<String, dynamic> json) => PackageType(
    type_id: json['type_id'],
    type_name: json['type_name'],
    type_length: json['type_length'],
    type_width: json['type_width'],
    type_height: json['type_height'],
    type_weight: json['type_weight'],
  );

  Map<String, dynamic> toMap() => {
    'type_id': type_id,
    'type_name': type_name,
    'type_length': type_length,
    'type_width': type_width,
    'type_height': type_height,
    'type_weight': type_weight,
  };
}