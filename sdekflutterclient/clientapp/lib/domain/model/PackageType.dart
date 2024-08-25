import 'package:equatable/equatable.dart';

class PackageType with EquatableMixin {
  final int? type_id;
  final String? type_name;
  final int? type_length;
  final int? type_width;
  final int? type_height;
  final int? type_weight;

  PackageType({
    this.type_id,
    this.type_name,
    this.type_length,
    this.type_width,
    this.type_height,
    this.type_weight
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    type_id,
    type_name,
    type_length,
    type_width,
    type_height,
    type_weight
  ];
}