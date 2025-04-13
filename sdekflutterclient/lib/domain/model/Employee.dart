import 'dart:convert';
import 'package:clientapp/domain/model/Position.dart';
import 'package:equatable/equatable.dart';
import 'User.dart';

class Employee with EquatableMixin {
  final String? employee_id;
  final String? employee_lastname;
  final String? employee_firstname;
  final String? employee_middlename;
  final Position employee_position;
  final User employee_user;

  Employee({
    this.employee_id,
    this.employee_lastname,
    this.employee_firstname,
    this.employee_middlename,
    required this.employee_position,
    required this.employee_user
  });

  @override
  List<Object?> get props => [
    employee_id,
    employee_lastname,
    employee_firstname,
    employee_middlename,
    employee_position,
    employee_user
  ];

  factory Employee.fromRawJson(String str) =>
      Employee.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  // ---------------------------------------------------------------------------
  // Maps
  // ---------------------------------------------------------------------------
  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
    employee_id: json['employee_id'],
    employee_lastname: json['employee_lastname'],
    employee_firstname: json['employee_firstname'],
    employee_middlename: json['employee_middlename'],
    employee_position: Position.fromMap(json['employee_position']),
    employee_user: User.fromMap(json['employee_user']),
  );

  Map<String, dynamic> toMap() => {
    'employee_id': employee_id,
    'employee_lastname': employee_lastname,
    'employee_firstname': employee_firstname,
    'employee_middlename': employee_middlename,
    'employee_position': employee_position.toMap(),
    'employee_user': employee_user.toMap(),
  };
}