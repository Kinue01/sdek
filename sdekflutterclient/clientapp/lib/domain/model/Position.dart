import 'package:equatable/equatable.dart';

class Position with EquatableMixin {

  final int? position_id;
  final String? position_name;
  final int? position_base_pay;

  Position({
    this.position_id,
    this.position_name,
    this.position_base_pay
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    position_id,
    position_name,
    position_base_pay
  ];
}