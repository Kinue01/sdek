import 'dart:convert';
import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/model/PackageItem.dart';
import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/domain/model/Transport.dart';
import 'package:equatable/equatable.dart';

class Package with EquatableMixin {
  final String? package_uuid;
  final Transport? package_transport;
  final PackageType? package_type;
  final Client? package_sender;
  final PackageStatus? package_status;
  final List<PackageItem>? package_items;

  Package({
    this.package_uuid,
    this.package_transport,
    this.package_type,
    this.package_sender,
    this.package_status,
    this.package_items
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    package_uuid,
    package_transport,
    package_type,
    package_sender,
    package_status,
    package_items
  ];

  factory Package.fromRawJson(String str) =>
      Package.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory Package.fromMap(Map<String, dynamic> json) => Package(
    package_uuid: json['package_uuid'],
    package_transport: json['package_transport_id'],
    package_type: json['package_type_id'],
    package_sender: json['package_sender_id'],
    package_status: json['package_status_id'],
  );

  Map<String, dynamic> toMap() => {
    'package_uuid': package_uuid,
    'package_transport_id': package_transport,
    'package_type_id': package_type,
    'package_sender_id': package_sender,
    'package_status_id': package_status,
  };
}