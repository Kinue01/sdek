import 'dart:convert';
import 'package:equatable/equatable.dart';

class PackageItem with EquatableMixin {
  final String? package_id;
  final String? item_name;
  final int? item_length;
  final int? item_width;
  final int? item_height;
  final int? item_weight;

  PackageItem({
    this.package_id,
    this.item_name,
    this.item_length,
    this.item_width,
    this.item_height,
    this.item_weight
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    package_id,
    item_name,
    item_length,
    item_width,
    item_height,
    item_weight
  ];

  factory PackageItem.fromRawJson(String str) =>
      PackageItem.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory PackageItem.fromMap(Map<String, dynamic> json) => PackageItem(
    package_id: json['package_id'],
    item_name: json['item_name'],
    item_length: json['item_length'],
    item_width: json['item_width'],
    item_height: json['item_height'],
    item_weight: json['item_weight'],
  );

  Map<String, dynamic> toMap() => {
    'package_id': package_id,
    'item_name': item_name,
    'item_length': item_length,
    'item_width': item_width,
    'item_height': item_height,
    'item_weight': item_weight,
  };
}