import 'dart:convert';

import 'package:equatable/equatable.dart';

class PackageStatus with EquatableMixin {
  final int? status_id;
  final String? status_name;

  PackageStatus({
    this.status_id,
    this.status_name
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    status_id,
    status_name
  ];

  factory PackageStatus.fromRawJson(String str) =>
      PackageStatus.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory PackageStatus.fromMap(Map<String, dynamic> json) => PackageStatus(
    status_id: json['status_id'],
    status_name: json['status_name'],
  );

  Map<String, dynamic> toMap() => {
    'status_id': status_id,
    'status_name': status_name,
  };
}