import 'dart:convert';

import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/model/TransportType.dart';
import 'package:equatable/equatable.dart';

class Transport with EquatableMixin {
  final int? transport_id;
  final String? transport_name;
  final TransportType transport_type;
  final Employee transport_driver;

  Transport({
    this.transport_id,
    this.transport_name,
    required this.transport_type,
    required this.transport_driver
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    transport_id,
    transport_name,
    transport_type,
    transport_driver
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
    transport_type: TransportType.fromRawJson(json['transport_type_id']),
    transport_driver: Employee.fromRawJson(json['transport_driver_id']),
  );

  Map<String, dynamic> toMap() => {
    'transport_id': transport_id,
    'transport_name': transport_name,
    'transport_type_id': transport_type.toRawJson(),
    'transport_driver_id': transport_driver.toRawJson(),
  };
}