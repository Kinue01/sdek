import 'dart:convert';

import 'package:clientapp/domain/model/TransportStatus.dart';
import 'package:clientapp/domain/model/TransportType.dart';
import 'package:equatable/equatable.dart';

class Transport with EquatableMixin {
  final int? transport_id;
  final String? transport_name;
  final String? transport_reg_number;
  late final TransportType? transport_type;
  final TransportStatus? transport_status;

  Transport({
    this.transport_id,
    this.transport_name,
    this.transport_reg_number,
    this.transport_type,
    this.transport_status
  });

  @override
  List<Object?> get props => [
    transport_id,
    transport_name,
    transport_reg_number,
    transport_type,
    transport_status
  ];
  
  factory Transport.fromRawJson(String str) =>
      Transport.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory Transport.fromMap(Map<String, dynamic> json) => Transport(
    transport_id: json['transport_id'],
    transport_name: json['transport_name'],
    transport_reg_number: json['transport_reg_number'],
    transport_type: TransportType.fromMap(json['transport_type']),
    transport_status: TransportStatus.fromMap(json['transport_status']),
  );

  Map<String, dynamic> toMap() => {
    'transport_id': transport_id,
    'transport_name': transport_name,
    'transport_reg_number': transport_reg_number,
    'transport_type': transport_type?.toMap(),
    'transport_status': transport_status?.toMap(),
  };
}