import 'package:equatable/equatable.dart';

class Role with EquatableMixin {

  final int? role_id;
  final String? role_name;

  Role({
    this.role_id,
    this.role_name
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    role_id,
    role_name
  ];
}