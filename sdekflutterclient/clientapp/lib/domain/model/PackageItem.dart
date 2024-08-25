import 'package:equatable/equatable.dart';

class PackageItem with EquatableMixin {
  final String? package_id;
  final String? item_name;
  final int? item_length;
  final int? item_width;
  final int? item_height;
  final int? item_weight;

  PackageItem({
    this.package_id,
    this.item_name,
    this.item_length,
    this.item_width,
    this.item_height,
    this.item_weight
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    package_id,
    item_name,
    item_length,
    item_width,
    item_height,
    item_weight
  ];
}