import 'dart:convert';

import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/model/Service.dart';
import 'package:equatable/equatable.dart';

class PackageServices with EquatableMixin {
  final Package? package;
  final Service? service;
  final int? service_count;

  PackageServices({
    this.package,
    this.service,
    this.service_count
  });

  @override
  List<Object?> get props => [
    package,
    service,
    service_count
  ];

  factory PackageServices.fromRawJson(String str) =>
      PackageServices.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory PackageServices.fromMap(Map<String, dynamic> json) => PackageServices(
    package: Package.fromMap(json['db_package']),
    service: Service.fromMap(json['service']),
    service_count: json['service_count'],
  );

  Map<String, dynamic> toMap() => {
    'db_package': package?.toMap(),
    'service': service?.toMap(),
    'service_count': service_count,
  };
}