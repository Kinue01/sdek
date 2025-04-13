import 'dart:convert';

import 'package:equatable/equatable.dart';

class Service with EquatableMixin {
  final int? service_id;
  final String? service_name;
  final int? service_pay;

  Service({
    this.service_id,
    this.service_name,
    this.service_pay
  });

  @override
  List<Object?> get props => [
    service_id,
    service_name,
    service_pay
  ];

  factory Service.fromRawJson(String str) =>
      Service.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory Service.fromMap(Map<String, dynamic> json) => Service(
    service_id: json['service_id'],
    service_name: json['service_name'],
    service_pay: json['service_pay'],
  );

  Map<String, dynamic> toMap() => {
    'service_id': service_id,
    'service_name': service_name,
    'service_pay': service_pay,
  };
}