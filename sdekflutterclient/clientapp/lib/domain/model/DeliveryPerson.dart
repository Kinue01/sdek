import 'dart:convert';

import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:equatable/equatable.dart';

class DeliveryPerson with EquatableMixin {
  final int? person_id;
  final String? person_lastname;
  final String? person_firstname;
  final String? person_middlename;
  final User? person_user;
  final Transport? person_transport;

  DeliveryPerson({
    this.person_id,
    this.person_lastname,
    this.person_firstname,
    this.person_middlename,
    this.person_user,
    this.person_transport
  });
  
  @override
  List<Object?> get props => [
    person_id,
    person_lastname,
    person_firstname,
    person_middlename,
    person_user,
    person_transport
  ];

  factory DeliveryPerson.fromRawJson(String str) =>
      DeliveryPerson.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory DeliveryPerson.fromMap(Map<String, dynamic> json) => DeliveryPerson(
    person_id: json['person_id'],
    person_lastname: json['person_lastname'],
    person_firstname: json['person_firstname'],
    person_middlename: json['person_middlename'],
    person_user: User.fromMap(json['person_user']),
    person_transport: Transport.fromMap(json['person_transport']),
  );

  Map<String, dynamic> toMap() => {
    'person_id': person_id,
    'person_lastname': person_lastname,
    'person_firstname': person_firstname,
    'person_middlename': person_middlename,
    'person_user': person_user?.toMap(),
    'person_transport': person_transport?.toMap(),
  };
}