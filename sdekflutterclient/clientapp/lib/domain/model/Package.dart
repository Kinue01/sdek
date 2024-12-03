import 'dart:convert';
import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/domain/model/PackageItem.dart';
import 'package:clientapp/domain/model/PackagePaytype.dart';
import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:equatable/equatable.dart';

class Package with EquatableMixin {
  final String? package_uuid;
  final DateTime? package_send_date;
  final DateTime? package_receive_date;
  final double? package_weight;
  final DeliveryPerson? package_deliveryperson;
  final PackageType? package_type;
  final PackageStatus? package_status;
  final Client? package_sender;
  final Client? package_receiver;
  final Warehouse? package_warehouse;
  final PackagePaytype? package_paytype;
  final Client? package_payer;
  final List<PackageItem>? package_items;

  Package({
    this.package_uuid,
    this.package_send_date,
    this.package_receive_date,
    this.package_weight,
    this.package_deliveryperson,
    this.package_type,
    this.package_status,
    this.package_sender,
    this.package_receiver,
    this.package_warehouse,
    this.package_paytype,
    this.package_payer,
    this.package_items
  });

  @override
  List<Object?> get props => [
    package_uuid,
    package_send_date,
    package_receive_date,
    package_weight,
    package_deliveryperson,
    package_type,
    package_status,
    package_sender,
    package_receiver,
    package_warehouse,
    package_paytype,
    package_payer,
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
    package_send_date: DateTime.tryParse(json['package_send_date']),
    package_receive_date: DateTime.tryParse(json['package_receive_date']),
    package_weight: double.tryParse(json['package_weight']),
    package_deliveryperson: DeliveryPerson.fromMap(json['package_deliveryperson']),
    package_type: PackageType.fromMap(json['package_type']),
    package_status: PackageStatus.fromMap(json['package_status']),
    package_sender: Client.fromMap(json['package_sender']),
    package_receiver: Client.fromMap(json['package_receiver']),
    package_warehouse: Warehouse.fromMap(json['package_warehouse']),
    package_paytype: PackagePaytype.fromMap(json['package_paytype']),
    package_payer: Client.fromMap(json['package_payer']),
    package_items: json['package_items'] == null ? [] : List<PackageItem>.from(json['package_items']!.map((dynamic x) => PackageItem.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    'package_uuid': package_uuid,
    'package_send_date': "${package_send_date?.year}-${package_send_date?.month}-${package_send_date?.day}",
    'package_receive_date': "${package_receive_date?.year}-${package_receive_date?.month}-${package_receive_date?.day}",
    'package_weight': package_weight,
    'package_deliveryperson': package_deliveryperson?.toMap(),
    'package_type': package_type?.toMap(),
    'package_status': package_status?.toMap(),
    'package_sender': package_sender?.toMap(),
    'package_receiver': package_receiver?.toMap(),
    'package_warehouse': package_warehouse?.toMap(),
    'package_paytype': package_paytype?.toMap(),
    'package_payer': package_payer?.toMap(),
    'package_items': package_items == null ? [null] : List<dynamic>.from(package_items!.map((x) => x.toMap()))
  };
}