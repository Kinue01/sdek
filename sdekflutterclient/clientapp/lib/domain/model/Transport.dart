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
}