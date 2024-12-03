import 'dart:convert';

import 'package:equatable/equatable.dart';

class TransportStatus with EquatableMixin {
  final int? status_id;
  final String? status_name;

  TransportStatus({
    this.status_id,
    this.status_name
  });

  @override
  List<Object?> get props => [
    status_id,
    status_name
  ];

  factory TransportStatus.fromRawJson(String str) =>
      TransportStatus.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory TransportStatus.fromMap(Map<String, dynamic> json) => TransportStatus(
    status_id: json['status_id'],
    status_name: json['status_name'],
  );

  Map<String, dynamic> toMap() => {
    'status_id': status_id,
    'status_name': status_name,
  };
}