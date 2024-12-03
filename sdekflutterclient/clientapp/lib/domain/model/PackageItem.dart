import 'dart:convert';
import 'package:equatable/equatable.dart';

class PackageItem with EquatableMixin {
  final int? item_id;
  final String? item_name;
  final String? item_description;
  final double? item_length;
  final double? item_width;
  final double? item_heigth;
  final double? item_weight;

  PackageItem({
    this.item_id,
    this.item_name,
    this.item_description,
    this.item_length,
    this.item_width,
    this.item_heigth,
    this.item_weight
  });

  @override
  List<Object?> get props => [
    item_id,
    item_name,
    item_description,
    item_length,
    item_width,
    item_heigth,
    item_weight
  ];

  factory PackageItem.fromRawJson(String str) =>
      PackageItem.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory PackageItem.fromMap(Map<String, dynamic> json) => PackageItem(
    item_id: json['item_id'],
    item_name: json['item_name'],
    item_description: json['item_description'],
    item_length: double.tryParse(json['item_length']),
    item_width: double.tryParse(json['item_width']),
    item_heigth: double.tryParse(json['item_heigth']),
    item_weight: double.tryParse(json['item_weight']),
  );

  Map<String, dynamic> toMap() => {
    'item_id': item_id,
    'item_name': item_name,
    'item_description': item_description,
    'item_length': item_length,
    'item_width': item_width,
    'item_heigth': item_heigth,
    'item_weight': item_weight,
  };
}