import 'package:equatable/equatable.dart';

class TransportType with EquatableMixin {

  final int? type_id;
  final String? type_name;

  TransportType({
    this.type_id,
    this.type_name,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    type_id,
    type_name,
  ];

}