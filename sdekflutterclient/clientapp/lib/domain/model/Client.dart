import 'package:clientapp/domain/model/User.dart';
import 'package:equatable/equatable.dart';

class Client with EquatableMixin {
  final int? client_id;
  final String? client_lastname;
  final String? client_firstname;
  final String? client_middlename;
  final User client_user;

  Client({
    this.client_id,
    this.client_lastname,
    this.client_firstname,
    this.client_middlename,
    required this.client_user
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    client_id,
    client_lastname,
    client_firstname,
    client_middlename,
    client_user
  ];
}